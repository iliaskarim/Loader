import SwiftUI

private struct Loader: View {
  private struct Parallelogram: Shape {
    let depth: CGFloat

    func path(in rect: CGRect) -> Path {
      Path { p in
        p.move(to: CGPoint(x: depth, y: 0))
        p.addLine(to: CGPoint(x: rect.width + depth, y: 0))
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
      }
    }
  }

  private let backgroundFill = HierarchicalShapeStyle.quinary
  private let duration = 2.0
  private let foregroundFill = HierarchicalShapeStyle.quaternary
  @Binding var isAnimating: Bool
  private let size: CGFloat = 12.0

  var body: some View {
    ZStack {
      Rectangle().fill(backgroundFill)

      GeometryReader { proxy in
        HStack {
          Group {
            let count = Int(proxy.size.width / (size * 2.0)) + 2
            ForEach(0..<count, id: \.self) { _ in
              Parallelogram(depth: size)
                .fill(foregroundFill)
                .frame(width: size, height: size)

              Spacer().frame(width: size)
            }
          }
        }
        .offset(CGSize(width: isAnimating ? -(size * 2.0) : 0.0, height: 0.0))
        .animation(isAnimating ? Animation.linear(duration: duration).repeatForever(autoreverses: false) : .default, value: isAnimating)
      }
    }.frame(height: size)
  }
}

struct ContentView: View {
  @State private var isAnimating = false

  var body: some View {
    Spacer()

    Button(action: {
        isAnimating.toggle()
    }) {
      Text("Start")
    }.disabled(isAnimating)

    Loader(isAnimating: $isAnimating)
    
    Spacer()
  }
}

#Preview {
  ContentView().frame(width: 150.0, height: 30.0)
}
