import SwiftUI
import StoreKit
// MARK: — paging scroll helper



class TouchFriendlyScrollView: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        // Always allow cancelling so drags still work
        return true
    }
}
struct PagingScrollView<Content: View>: UIViewRepresentable {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }

    func makeUIView(context: Context) -> UIScrollView {
        // 1. Create scroll view
        let scroll = TouchFriendlyScrollView()

        // 2. Allow buttons inside to receive taps immediately
        scroll.delaysContentTouches = false
        scroll.canCancelContentTouches = true

        // 3. Your existing scroll configuration
        scroll.isPagingEnabled = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.bounces = true
        scroll.decelerationRate = .fast
        scroll.delegate = context.coordinator

        // 4. Host the SwiftUI content
        let hosted = UIHostingController(rootView:
            HStack(spacing: 20, content: content)
        )
        hosted.view.translatesAutoresizingMaskIntoConstraints = false
        hosted.view.backgroundColor = .clear
        scroll.addSubview(hosted.view)

        // 5. Constrain hosted view to scroll view
        NSLayoutConstraint.activate([
            hosted.view.topAnchor.constraint(equalTo: scroll.topAnchor),
            hosted.view.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            hosted.view.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 32),
            hosted.view.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -32),
            hosted.view.heightAnchor.constraint(equalTo: scroll.heightAnchor)
        ])

        // 6. Keep references in coordinator
        context.coordinator.scrollView = scroll
        context.coordinator.hostedView = hosted.view

        return scroll
    }


    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if let hosted = uiView.subviews.first?.next
            as? UIHostingController<HStack<TupleView<(Content)>>> {
            hosted.rootView = HStack(spacing: 20) { content() }
                as! HStack<TupleView<(Content)>>
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }
    class Coordinator: NSObject, UIScrollViewDelegate {
        weak var scrollView: UIScrollView?
        weak var hostedView: UIView?

        func scrollViewWillEndDragging(
            _ scrollView: UIScrollView,
            withVelocity velocity: CGPoint,
            targetContentOffset: UnsafeMutablePointer<CGPoint>
        ) {
            let spacing: CGFloat = 20
            let cardW = UIScreen.main.bounds.width * 0.75
            let pageW = cardW + spacing
            let offset = scrollView.contentOffset.x + scrollView.contentInset.left
            let idx = round(offset / pageW)
            targetContentOffset.pointee = CGPoint(
                x: idx * pageW - scrollView.contentInset.left,
                y: 0
            )
        }
    }
}

// MARK: — Emotional Map detail placeholder
struct EmotionalMapDetailView: View {
    var body: some View {
        Text("Your Emotional Map Progress")
            .font(.title)
            .padding()
            .navigationTitle("My Progress")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: — your home page
struct HomePageView: View {
    @StateObject private var skyVM = SkyViewModel()
    @State private var currentIndex = 1
    @State private var showProblemView = false
    
    private let cards = [
        (title: "Problem Solver",
         subtitle: "Instant Solutions to Your Problems",
         image: "problem_solver",
         actionText: "Solve"),
        (title: "General Therapy",
         subtitle: "Talk with a Professional",
         image: "general_therapy",
         actionText: "Talk"),
        (title: "Daily Lesson",
         subtitle: "Learn Something New Every Day",
         image: "daily_lesson",
         actionText: "Learn")
    ]

    private func bgImage(for i: Int) -> String {
        switch i {
        case 0: return "ProblemPic"
        case 1: return "GeneralPic"
        case 2: return "DailyLessonPic"
        default: return cards[i].image
        }
    }

    private func getScale(_ geo: GeometryProxy) -> CGFloat {
        let mid = UIScreen.main.bounds.width / 2
        let x = geo.frame(in: .global).midX
        let dist = abs(mid - x)
        let tol: CGFloat = 150
        return max(1 - (dist / tol) * 0.2, 0.9)
    }

    var body: some View {
        NavigationView {
            ZStack {
                // dark gradient background
                LinearGradient(
                    gradient: .init(colors: [.black, .black, .black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                // stars & shooting stars
                StarField(count: 150)
                ShootingStarCanvas(vm: skyVM)

                GeometryReader { proxy in
                    // compute 10% of screen height for bar
                    let barHeight = proxy.size.height * 0.01
                    let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0

                    VStack(spacing: 0) {
                        // Top Bar
                        VStack {
                            HStack {
                                Image("Clarity_logo")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
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
                        }
                        .background(
                            LinearGradient(
                                gradient: .init(colors: [Color.black.opacity(0.65), Color.black.opacity(0.65)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .zIndex(1)

                        // Main Content
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(spacing: 20) {
                                // carousel
                                // ── NEW: SwiftUI TabView paging carousel ──
                                // ── Replace your GeometryReader + PagingScrollView block with this ──

                                TabView(selection: $currentIndex) {
                                    ForEach(Array(cards.enumerated()), id: \.offset) { idx, card in
                                        GeometryReader { geo in
                                            // compute scale based on this page’s position
                                            let scale = getScale(geo)

                                            ZStack(alignment: .bottomLeading) {
                                                Image(bgImage(for: idx))
                                                    .resizable()
                                                    .aspectRatio(1825/2737, contentMode: .fill)
                                                    .frame(
                                                        width: UIScreen.main.bounds.width * 0.75,
                                                        height: 400
                                                    )
                                                    .cornerRadius(25)
                                                    .overlay(
                                                        LinearGradient(
                                                            gradient: Gradient(colors: [Color.black.opacity(0.6), .clear]),
                                                            startPoint: .bottom,
                                                            endPoint: .top
                                                        )
                                                    )
                                                    .clipped()
                                                    .shadow(radius: 5)
                                                    .scaleEffect(scale)               // <-- use the computed scale
                                                    .animation(.easeInOut(duration: 0.3), value: currentIndex)

                                                VStack(alignment: .leading, spacing: 12) {
                                                    Text(card.title)
                                                        .font(.title2)
                                                        .bold()
                                                    Text(card.subtitle)
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)

                                                    HStack(spacing: 12) {
                                                        // Solve button
                                                        Button {
                                                            print("🛠 Solve tapped")
                                                            showProblemView = true
                                                        } label: {
                                                            HStack {
                                                                Image(systemName: "play.fill")
                                                                Text(card.actionText)
                                                            }
                                                            .padding()
                                                            .background(Color.white)
                                                            .foregroundColor(.black)
                                                            .cornerRadius(10)
                                                        }

                                                        // History button
                                                        Button {
                                                            // history action
                                                        } label: {
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
                                        .frame(
                                            width: UIScreen.main.bounds.width * 0.75,
                                            height: 420
                                        )
                                        .tag(idx)
                                    }
                                }
                                .frame(height: 420)
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .indexViewStyle(.page(backgroundDisplayMode: .never))

                                // Emotional Map card
                                NavigationLink(destination: EmotionalMapDetailView()) {
                                    ZStack(alignment: .leading) {
                                        Image("ProgressPic")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(
                                                width: UIScreen.main.bounds.width * 0.9,
                                                height: 220
                                            )
                                            .cornerRadius(25)
                                            .clipped()
                                            .overlay(Color.black.opacity(0.4))

                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Emotional Map").font(.title).bold()
                                            Text("See What You’re Feeling")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            HStack {
                                                Image(systemName: "chart.bar.fill")
                                                Text("View Progress")
                                            }
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        }
                                        .padding()
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                            }
                            .foregroundColor(.white)
                        }

                        // Custom Bottom Navigation Bar
                        HStack(spacing: 0) {
                            BottomNavItem(icon: "house.fill", title: "Home")
                            BottomNavItem(icon: "chart.bar.fill", title: "My Progress")
                            BottomNavItem(icon: "books.vertical.fill", title: "Library")
                        }
                        .padding(.top, 35)
                        .frame(height: barHeight + bottomInset)
                        .padding(.bottom, bottomInset)
                        .background(BlurView(style: .systemMaterialDark))
                    }
                    .frame(height: proxy.size.height)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: — supporting views

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct BottomNavItem: View {
    let icon: String, title: String
    var body: some View {
        VStack(spacing: 4) {
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
