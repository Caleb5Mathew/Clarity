//
//  StarField.swift
//  Clarity
//
//  Created by user941803 on 5/6/25.
//


import SwiftUI
import UIKit  // needed for safe-area insets

// MARK: — a simple “star field” overlay
struct StarField: View {
    struct Star { let x: CGFloat, y: CGFloat, size: CGFloat, opacity: Double }
    let stars: [Star]

    init(count: Int) {
        let screen = UIScreen.main.bounds.size
        self.stars = (0..<count).map { _ in
            Star(
                x: .random(in: 0...screen.width),
                y: .random(in: 0...screen.height),
                size: .random(in: 1...2),
                opacity: .random(in: 0.3...1)
            )
        }
    }

    var body: some View {
        Canvas { ctx, size in
            for star in stars {
                let rect = CGRect(
                    x: star.x,
                    y: star.y,
                    width: star.size,
                    height: star.size
                )
                ctx.fill(
                    Path(ellipseIn: rect),
                    with: .color(.white.opacity(star.opacity))
                )
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: — shooting star model & view model
struct ShootingStar: Identifiable {
    let id = UUID()
    let start: CGPoint
    let vector: CGVector
    var progress: CGFloat = 0
    let duration: Double
}

class SkyViewModel: ObservableObject {
    @Published var shootingStars: [ShootingStar] = []
    private var timer: Timer?

    init() {
        // spawn one every 4 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { [weak self] _ in
            self?.spawnStar()
        }
    }

    func spawnStar() {
        let screen = UIScreen.main.bounds.size
        let edge = Int.random(in: 0...3)
        var start: CGPoint, vector: CGVector
        let length: CGFloat = 200
        let duration: Double = Double.random(in: 0.8...1.2)

        switch edge {
        case 0:
            start = CGPoint(x: .random(in: 0...screen.width), y: 0)
            vector = CGVector(dx: length * 0.7, dy: length)
        case 1:
            start = CGPoint(x: screen.width, y: .random(in: 0...screen.height))
            vector = CGVector(dx: -length, dy: length * 0.5)
        case 2:
            start = CGPoint(x: .random(in: 0...screen.width), y: screen.height)
            vector = CGVector(dx: -length * 0.8, dy: -length)
        default:
            start = CGPoint(x: 0, y: .random(in: 0...screen.height))
            vector = CGVector(dx: length, dy: -length * 0.6)
        }

        let star = ShootingStar(start: start, vector: vector, duration: duration)
        withAnimation(.linear(duration: duration)) {
            var animating = star
            animating.progress = 1
            shootingStars.append(animating)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.shootingStars.removeAll { $0.id == star.id }
        }
    }
}

// MARK: — shooting star canvas
struct ShootingStarCanvas: View {
    @ObservedObject var vm: SkyViewModel

    var body: some View {
        Canvas { ctx, size in
            for star in vm.shootingStars {
                let end = CGPoint(
                    x: star.start.x + star.vector.dx * star.progress,
                    y: star.start.y + star.vector.dy * star.progress
                )
                var path = Path()
                path.move(to: star.start)
                path.addLine(to: end)

                let gradient = Gradient(colors: [Color.white, Color.white.opacity(0)])
                ctx.stroke(
                    path,
                    with: .linearGradient(
                        gradient,
                        startPoint: star.start,
                        endPoint: end
                    ),
                    lineWidth: 2
                )
            }
        }
        .ignoresSafeArea()
    }
}
