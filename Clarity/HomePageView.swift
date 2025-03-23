import SwiftUI

// MARK: PagingScrollView UIViewRepresentable
struct PagingScrollView<Content: View>: UIViewRepresentable {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false // Disable default paging
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.decelerationRate = .fast
        scrollView.delegate = context.coordinator

        let hostedView = UIHostingController(rootView:
            HStack(spacing: 20, content: content)
        )
        hostedView.view.translatesAutoresizingMaskIntoConstraints = false
        hostedView.view.backgroundColor = .clear
        scrollView.addSubview(hostedView.view)

        NSLayoutConstraint.activate([
            hostedView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostedView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostedView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32),
            hostedView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -32),
            hostedView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        context.coordinator.scrollView = scrollView
        context.coordinator.hostedView = hostedView.view

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if let hostedView = uiView.subviews.first {
            if let hostingController = hostedView.next as? UIHostingController<HStack<TupleView<(Content)>>> {
                hostingController.rootView = HStack(spacing: 20) {
                    content()
                } as! HStack<TupleView<(Content)>>
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        weak var scrollView: UIScrollView?
        weak var hostedView: UIView?

        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            guard let hostedView = hostedView else { return }

            let totalSpacing: CGFloat = 20
            let cardWidth = UIScreen.main.bounds.width * 0.75
            let pageWidth = cardWidth + totalSpacing
            let offset = scrollView.contentOffset.x + scrollView.contentInset.left
            let index = round(offset / pageWidth)
            let newOffset = index * pageWidth - scrollView.contentInset.left
            targetContentOffset.pointee = CGPoint(x: newOffset, y: 0)
        }
    }
}


struct HomePageView: View {
    @State private var selectedCategory: String = "New & For You"
    private let categories = ["Home", "Videos", "Coming Soon..."]
    @State private var currentIndex: Int = 1
    @State private var scrollOffset: CGFloat = 0
    @State private var dragging: Bool = false
    @GestureState private var dragOffset: CGFloat = 0
    private let cards = [
        (title: "Problem Solver", subtitle: "Instant Solutions to Your Problems", image: "problem_solver", actionText: "Solve"),
        (title: "General Therapy", subtitle: "Talk with a Professional", image: "general_therapy", actionText: "Talk"),
        (title: "Daily Lesson", subtitle: "Learn Something New Every Day", image: "daily_lesson", actionText: "Learn")
    ]

    private func backgroundImageName(for index: Int) -> String {
        switch index {
        case 0:
            return "ProblemPic"
        case 1:
            return "GeneralPic"
        case 2:
            return "DailyLessonPic"
        default:
            return cards[index].image
        }
    }

    private func getScale(geometry: GeometryProxy) -> CGFloat {
        let midPoint = UIScreen.main.bounds.width / 2
        let viewMidX = geometry.frame(in: .global).midX
        let distance = abs(midPoint - viewMidX)
        let tolerance: CGFloat = 150
        let scale = max(1 - (distance / tolerance) * 0.2, 0.9)
        return scale
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 20) {
                            HStack {
                                Image("Clarity_logo")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .padding(.bottom, 5)

                            GeometryReader { outerGeometry in
                                PagingScrollView {
                                    ForEach(Array(cards.enumerated()), id: \ .offset) { index, card in
                                        GeometryReader { geometry in
                                            ZStack(alignment: .bottomLeading) {
                                                Image(backgroundImageName(for: index))
                                                    .resizable()
                                                    .aspectRatio(1825/2737, contentMode: .fill)
                                                    .frame(width: UIScreen.main.bounds.width * 0.75, height: 400)
                                                    .cornerRadius(25)
                                                    .overlay(
                                                        LinearGradient(
                                                            gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                                                            startPoint: .bottom,
                                                            endPoint: .top
                                                        )
                                                    )
                                                    .clipped()
                                                    .shadow(radius: 5)
                                                    .scaleEffect(getScale(geometry: geometry))
                                                    .animation(.easeInOut(duration: 0.3), value: getScale(geometry: geometry))

                                                VStack(alignment: .leading) {
                                                    Text(card.title)
                                                        .font(.largeTitle)
                                                        .bold()
                                                    Text(card.subtitle)
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                    HStack {
                                                        Button(action: {}) {
                                                            HStack {
                                                                Image(systemName: "play.fill")
                                                                Text(card.actionText)
                                                            }
                                                            .padding()
                                                            .background(Color.white)
                                                            .foregroundColor(.black)
                                                            .cornerRadius(10)
                                                        }
                                                        Button(action: {}) {
                                                            HStack {
                                                                Image(systemName: "clock")
                                                                Text("History")
                                                            }
                                                            .padding()
                                                            .background(Color.gray.opacity(0.8))
                                                            .foregroundColor(.white)
                                                            .cornerRadius(10)
                                                        }
                                                    }
                                                }
                                                .padding()
                                            }
                                            .padding(.vertical)
                                        }
                                        .frame(width: UIScreen.main.bounds.width * 0.75, height: 420)
                                    }
                                }
                                .frame(height: 420)
                            }
                            .frame(height: 420)

                            ZStack(alignment: .leading) {
                                Image("ProgressPic")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 220)
                                    .cornerRadius(25)
                                    .clipped()
                                    .overlay(Color.black.opacity(0.4))

                                VStack(alignment: .leading, spacing: 10) {
                                    Text("See Your Progress")
                                        .font(.title)
                                        .bold()
                                    Text("Track how far you've come")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Button(action: {}) {
                                        HStack {
                                            Image(systemName: "chart.bar.fill")
                                            Text("View Progress")
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                    }
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .padding(.bottom, 30)
                        }
                        .foregroundColor(.white)
                    }

                    HStack {
                        BottomNavItem(icon: "house.fill", title: "Home")
                        BottomNavItem(icon: "chart.bar.fill", title: "My Progress")
                        BottomNavItem(icon: "books.vertical.fill", title: "Library")
                    }
                    .padding()
                    .background(BlurView(style: .systemUltraThinMaterial))
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct BottomNavItem: View {
    let icon: String
    let title: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 25, height: 25)
            Text(title)
                .font(.caption)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}


//import SwiftUI
//
//// MARK: PagingScrollView UIViewRepresentable
//struct PagingScrollView<Content: View>: UIViewRepresentable {
//    let content: () -> Content
//
//    init(@ViewBuilder content: @escaping () -> Content) {
//        self.content = content
//    }
//
//    func makeUIView(context: Context) -> UIScrollView {
//        let scrollView = UIScrollView()
//        scrollView.isPagingEnabled = true
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.bounces = true
//
//        let hostedView = UIHostingController(rootView: HStack(spacing: 20, content: content))
//        hostedView.view.translatesAutoresizingMaskIntoConstraints = false
//        hostedView.view.backgroundColor = .clear
//        scrollView.addSubview(hostedView.view)
//
//        NSLayoutConstraint.activate([
//            hostedView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            hostedView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            hostedView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32),
//            hostedView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -32),
//            hostedView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
//        ])
//
//        return scrollView
//    }
//
//    func updateUIView(_ uiView: UIScrollView, context: Context) {
//        if let hostedView = uiView.subviews.first {
//            if let hostingController = hostedView.next as? UIHostingController<HStack<TupleView<(Content)>>> {
//                hostingController.rootView = HStack(spacing: 20) {
//                    content()
//                } as! HStack<TupleView<(Content)>>
//            }
//        }
//    }
//
//}
//
//
//struct HomePageView: View {
//    @State private var selectedCategory: String = "New & For You"
//    private let categories = ["Home", "Videos", "Coming Soon..."]
//    @State private var currentIndex: Int = 1
//    @State private var scrollOffset: CGFloat = 0
//    @State private var dragging: Bool = false
//    @GestureState private var dragOffset: CGFloat = 0
//    private let cards = [
//        (title: "Problem Solver", subtitle: "Instant Solutions to Your Problems", image: "problem_solver", actionText: "Solve"),
//        (title: "General Therapy", subtitle: "Talk with a Professional", image: "general_therapy", actionText: "Talk"),
//        (title: "Daily Lesson", subtitle: "Learn Something New Every Day", image: "daily_lesson", actionText: "Learn")
//    ]
//
//    private func backgroundImageName(for index: Int) -> String {
//        switch index {
//        case 0:
//            return "ProblemPic"
//        case 1:
//            return "GeneralPic"
//        case 2:
//            return "DailyLessonPic"
//        default:
//            return cards[index].image
//        }
//    }
//
//    private func getScale(geometry: GeometryProxy) -> CGFloat {
//        let midPoint = UIScreen.main.bounds.width / 2
//        let viewMidX = geometry.frame(in: .global).midX
//        let distance = abs(midPoint - viewMidX)
//        let tolerance: CGFloat = 150
//        let scale = max(1 - (distance / tolerance) * 0.2, 0.9)
//        return scale
//    }
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black.edgesIgnoringSafeArea(.all)
//
//                VStack(spacing: 0) {
//                    ScrollView(.vertical, showsIndicators: true) {
//                        VStack(spacing: 20) {
//                            HStack {
//                                Image("Clarity_logo")
//                                    .resizable()
//                                    .frame(width: 50, height: 50)
//                                Spacer()
//                                Image(systemName: "magnifyingglass")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                                    .foregroundColor(.white)
//                                Image(systemName: "person.circle.fill")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .foregroundColor(.white)
//                            }
//                            .padding(.horizontal)
//                            .padding(.top, 10)
//                            .padding(.bottom, 5)
//
//                            PagingScrollView {
//                                ForEach(Array(cards.enumerated()), id: \.offset) { index, card in
//                                    GeometryReader { geometry in
//                                        ZStack(alignment: .bottomLeading) {
//                                            Image(backgroundImageName(for: index))
//                                                .resizable()
//                                                .aspectRatio(1825/2737, contentMode: .fill)
//                                                .frame(width: UIScreen.main.bounds.width * 0.75, height: 400)
//                                                .cornerRadius(25)
//                                                .overlay(
//                                                    LinearGradient(
//                                                        gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
//                                                        startPoint: .bottom,
//                                                        endPoint: .top
//                                                    )
//                                                )
//                                                .clipped()
//                                                .shadow(radius: 5)
//                                                .scaleEffect(getScale(geometry: geometry))
//                                                .animation(.easeInOut(duration: 0.3), value: getScale(geometry: geometry))
//
//                                            VStack(alignment: .leading) {
//                                                Text(card.title)
//                                                    .font(.largeTitle)
//                                                    .bold()
//                                                Text(card.subtitle)
//                                                    .font(.subheadline)
//                                                    .foregroundColor(.gray)
//                                                HStack {
//                                                    Button(action: {}) {
//                                                        HStack {
//                                                            Image(systemName: "play.fill")
//                                                            Text(card.actionText)
//                                                        }
//                                                        .padding()
//                                                        .background(Color.white)
//                                                        .foregroundColor(.black)
//                                                        .cornerRadius(10)
//                                                    }
//                                                    Button(action: {}) {
//                                                        HStack {
//                                                            Image(systemName: "clock")
//                                                            Text("History")
//                                                        }
//                                                        .padding()
//                                                        .background(Color.gray.opacity(0.8))
//                                                        .foregroundColor(.white)
//                                                        .cornerRadius(10)
//                                                    }
//                                                }
//                                            }
//                                            .padding()
//                                        }
//                                        .padding(.vertical)
//                                    }
//                                    .frame(width: UIScreen.main.bounds.width * 0.75, height: 420)
//                                }
//                            }
//                            .frame(height: 420)
//
//
//                            ZStack(alignment: .leading) {
//                                Image("ProgressPic")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 220)
//                                    .cornerRadius(25)
//                                    .clipped()
//                                    .overlay(Color.black.opacity(0.4))
//
//                                VStack(alignment: .leading, spacing: 10) {
//                                    Text("See Your Progress")
//                                        .font(.title)
//                                        .bold()
//                                    Text("Track how far you've come")
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                    Button(action: {}) {
//                                        HStack {
//                                            Image(systemName: "chart.bar.fill")
//                                            Text("View Progress")
//                                        }
//                                        .padding()
//                                        .background(Color.white)
//                                        .foregroundColor(.black)
//                                        .cornerRadius(10)
//                                    }
//                                }
//                                .padding()
//                            }
//                            .padding(.horizontal)
//                            .padding(.top, 10)
//                            .padding(.bottom, 30)
//                        }
//                        .foregroundColor(.white)
//                    }
//
//                    HStack {
//                        BottomNavItem(icon: "house.fill", title: "Home")
//                        BottomNavItem(icon: "chart.bar.fill", title: "My Progress")
//                        BottomNavItem(icon: "books.vertical.fill", title: "Library")
//                    }
//                    .padding()
//                    .background(BlurView(style: .systemUltraThinMaterial))
//                    .edgesIgnoringSafeArea(.bottom)
//                }
//            }
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//struct BlurView: UIViewRepresentable {
//    var style: UIBlurEffect.Style
//    func makeUIView(context: Context) -> UIVisualEffectView {
//        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
//        return view
//    }
//    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
//}
//
//struct BottomNavItem: View {
//    let icon: String
//    let title: String
//
//    var body: some View {
//        VStack {
//            Image(systemName: icon)
//                .resizable()
//                .frame(width: 25, height: 25)
//            Text(title)
//                .font(.caption)
//        }
//        .foregroundColor(.white)
//        .frame(maxWidth: .infinity)
//    }
//}
//
//struct HomePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePageView()
//    }
//}

//
//
//
//
//import SwiftUI
//
//struct HomePageView: View {
//    @State private var selectedCategory: String = "New & For You"
//    private let categories = ["Home", "Videos", "Coming Soon..."]
//    @State private var currentIndex: Int = 1
//    private let cards = [
//        (title: "Problem Solver", subtitle: "Instant Solutions to Your Problems", image: "problem_solver", actionText: "Solve"),
//        (title: "General Therapy", subtitle: "Talk with a Professional", image: "general_therapy", actionText: "Talk"),
//        (title: "Daily Lesson", subtitle: "Learn Something New Every Day", image: "daily_lesson", actionText: "Learn")
//    ]
//    
//    private func backgroundImageName(for index: Int) -> String {
//        switch index {
//        case 0:
//            return "ProblemPic"
//        case 1:
//            return "GeneralPic"
//        case 2:
//            return "DailyLessonPic"
//        default:
//            return cards[index].image // fallback (keeps structure)
//        }
//    }
//    
//    // Carousel scaling effect
//    private func getScale(geometry: GeometryProxy) -> CGFloat {
//        let midPoint = UIScreen.main.bounds.width / 2
//        let viewMidX = geometry.frame(in: .global).midX
//        let distance = abs(midPoint - viewMidX)
//        let tolerance: CGFloat = 150
//        let scale = max(1 - (distance / tolerance) * 0.2, 0.9)
//        return scale
//    }
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black.edgesIgnoringSafeArea(.all) // Makes entire background black
//                
//                VStack(spacing: 0) {
//                    ScrollView(.vertical, showsIndicators: true) {
//                        VStack(spacing: 20) { // Adds consistent spacing between sections
//                            
//                            // TOP BAR
//                            HStack {
//                                Image("Clarity_logo")
//                                    .resizable()
//                                    .frame(width: 50, height: 50)
//                                Spacer()
//                                Image(systemName: "magnifyingglass")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                                    .foregroundColor(.white)
//                                Image(systemName: "person.circle.fill")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .foregroundColor(.white)
//                            }
//                            .padding(.horizontal)
//                            .padding(.top, 10)
//                            .padding(.bottom, 5)
//                            
//                            // CATEGORY TABS
//                            // MARK: - Custom Carousel
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                HStack(spacing: 20) { // spacing gives peeking effect!
//                                    ForEach(0..<cards.count, id: \.self) { index in
//                                        GeometryReader { geometry in
//                                            ZStack(alignment: .bottomLeading) {
//                                                Image(backgroundImageName(for: index))
//                                                    .resizable()
//                                                    .aspectRatio(1825/2737, contentMode: .fill)
//                                                    .frame(width: UIScreen.main.bounds.width * 0.75, height: 400)
//                                                    .cornerRadius(25)
//                                                    .overlay(
//                                                        LinearGradient(
//                                                            gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
//                                                            startPoint: .bottom,
//                                                            endPoint: .top
//                                                        )
//                                                    )
//                                                    .clipped()
//                                                    .shadow(radius: 5)
//                                                    .scaleEffect(getScale(geometry: geometry)) // zoom effect
//                                                    .animation(.easeInOut(duration: 0.3), value: getScale(geometry: geometry))
//                                                
//                                                VStack(alignment: .leading) {
//                                                    Text(cards[index].title)
//                                                        .font(.largeTitle)
//                                                        .bold()
//                                                    Text(cards[index].subtitle)
//                                                        .font(.subheadline)
//                                                        .foregroundColor(.gray)
//                                                    HStack {
//                                                        Button(action: {}) {
//                                                            HStack {
//                                                                Image(systemName: "play.fill")
//                                                                Text(cards[index].actionText)
//                                                            }
//                                                            .padding()
//                                                            .background(Color.white)
//                                                            .foregroundColor(.black)
//                                                            .cornerRadius(10)
//                                                        }
//                                                        Button(action: {}) {
//                                                            HStack {
//                                                                Image(systemName: "clock")
//                                                                Text("History")
//                                                            }
//                                                            .padding()
//                                                            .background(Color.gray.opacity(0.8))
//                                                            .foregroundColor(.white)
//                                                            .cornerRadius(10)
//                                                        }
//                                                    }
//                                                }
//                                                .padding()
//                                            }
//                                            .padding(.vertical)
//                                        }
//                                        .frame(width: UIScreen.main.bounds.width * 0.75, height: 420)
//                                    }
//                                }
//                                .padding(.horizontal, 32)
//                            }
//
//                            
//                            
//
//                            // SEE YOUR PROGRESS SECTION
//                            ZStack(alignment: .leading) {
//                                Image("ProgressPic")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 220)
//                                    .cornerRadius(25)
//                                    .clipped()
//                                    .overlay(Color.black.opacity(0.4))
//                                
//                                VStack(alignment: .leading, spacing: 10) {
//                                    Text("See Your Progress")
//                                        .font(.title)
//                                        .bold()
//                                    Text("Track how far you've come")
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                    Button(action: {}) {
//                                        HStack {
//                                            Image(systemName: "chart.bar.fill")
//                                            Text("View Progress")
//                                        }
//                                        .padding()
//                                        .background(Color.white)
//                                        .foregroundColor(.black)
//                                        .cornerRadius(10)
//                                    }
//                                }
//                                .padding()
//                            }
//                            .padding(.horizontal)
//                            .padding(.top, 10)
//                            .padding(.bottom, 30)
//                        }
//                        .foregroundColor(.white)
//                    }
//                    
//                    // STICKY BOTTOM NAV BAR OUTSIDE SCROLL
//                    HStack {
//                        BottomNavItem(icon: "house.fill", title: "Home")
//                        BottomNavItem(icon: "chart.bar.fill", title: "My Progress")
//                        BottomNavItem(icon: "books.vertical.fill", title: "Library")
//                    }
//                    .padding()
//                    .background(BlurView(style: .systemUltraThinMaterial))
//                    .edgesIgnoringSafeArea(.bottom) // Sticky to screen edge
//                }
//            }
//            .navigationBarHidden(true)
//        }
//    }
//    
//}
//// BlurView & BottomNavItem unchanged:
//struct BlurView: UIViewRepresentable {
//    var style: UIBlurEffect.Style
//    func makeUIView(context: Context) -> UIVisualEffectView {
//        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
//        return view
//    }
//    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
//}
//
//struct BottomNavItem: View {
//    let icon: String
//    let title: String
//    
//    var body: some View {
//        VStack {
//            Image(systemName: icon)
//                .resizable()
//                .frame(width: 25, height: 25)
//            Text(title)
//                .font(.caption)
//        }
//        .foregroundColor(.white)
//        .frame(maxWidth: .infinity)
//    }
//}
//
//struct HomePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePageView()
//    }
//}
