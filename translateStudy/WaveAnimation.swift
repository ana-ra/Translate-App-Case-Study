//
//  WaveAnimation.swift
//  translateStudy
//
//  Created by Raphael Ferezin Kitahara on 30/05/23.
//

import Foundation
import SwiftUI

struct WaveView: View {
    @State private var amplitude: CGFloat = 0.5
    @State private var phase: CGFloat = 0.0
    @State private var change: CGFloat = 0.1

    var body: some View {
        VStack {
            MultiWave(amplitude: amplitude, color: .teal, phase: phase)
                .frame(height: 100)
                .onAppear {
                    withAnimation(Animation.linear(duration: 0.1)
                                    .repeatForever(autoreverses: false)
                    ) {
                        self.amplitude = _nextAmplitude()
                        self.phase -= 1.5
                    }
                }
                .onAnimationCompleted(for: amplitude) {
                    withAnimation(.linear(duration: 0.1)){
                        self.amplitude = _nextAmplitude()
                        self.phase -= 1.5
                    }
                }
        }
    }

    private func _nextAmplitude() -> CGFloat {
        // If the amplitude is too low or too high, cap it and go in the other direction.
        if self.amplitude <= 0.01 {
            self.change = 0.1
            return 0.02
        } else if self.amplitude > 0.9 {
            self.change = -0.1
            return 0.9
        }

        // Simply set the amplitude to whatever you need and the view will update itself.
        let newAmplitude = self.amplitude + (self.change * CGFloat.random(in: 0.3...0.8))
        return max(0.01, newAmplitude)
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView()
    }
}

struct Wave: Shape {
    /// The frequency of the sinus wave. The higher the value, the more sinus wave peaks you will have.
    /// Default: 1.5
    var frequency: CGFloat = 1.5

    /// The lines are joined stepwise, the more dense you draw, the more CPU power is used.
    /// Default: 1
    var density: CGFloat = 1.0

    /// The phase shift that will be applied
    var phase: CGFloat
    
    /// The normed ampllitude of this wave, between 0 and 1.
    var normedAmplitude: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let maxAmplitude = rect.height / 2.0
        let mid = rect.width / 2
        
        for x in Swift.stride(from:0, to: rect.width + self.density, by: self.density) {
            // Parabolic scaling
            let scaling = -pow(1 / mid * (x - mid), 2) + 1
            let y = scaling * maxAmplitude * normedAmplitude * sin(CGFloat(2 * Double.pi) * self.frequency * (x / rect.width)  + self.phase) + rect.height / 2
            if x == 0 {
                path.move(to: CGPoint(x:x, y:y))
            } else {
                path.addLine(to: CGPoint(x:x, y:y))
            }
        }
        
        return path
    }
    
    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            AnimatablePair(normedAmplitude, phase)
        }
        
        set {
            self.normedAmplitude = newValue.first
            self.phase = newValue.second
        }
    }
}


struct MultiWave: View {
    var amplitude: CGFloat = 1.0
    var color: Color = Color.green
    var phase: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            ForEach((0...4), id: \.self) { count in
                singleWave(count: count)
            }
        }
    }
    
    func singleWave(count: Int) -> some View {
        let progress = 1.0 - CGFloat(count) / CGFloat(5)
        let normedAmplitude = (1.5 * progress - 0.8) * self.amplitude
        let alphaComponent = min(1.0, (progress/3.0*2.0) + (1.0/3.0))

        return Wave(phase: phase, normedAmplitude: normedAmplitude)
            .stroke(color.opacity(Double(alphaComponent)), lineWidth: 1.5 / CGFloat(count + 1))
    }
    
}

struct MultiWave_Previews: PreviewProvider {
    static var previews: some View {
        MultiWave()
    }
}


extension View {
    
    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
}


/// An animatable modifier that is used for observing animations for a given animatable value.
struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {
    
    /// While animating, SwiftUI changes the old input value to the new target value using this property. This value is set to the old value until the animation completes.
    var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }
    
    /// The target value for which we're observing. This value is directly set once the animation starts. During animation, `animatableData` will hold the oldValue and is only updated to the target value once the animation completes.
    private var targetValue: Value
    
    /// The completion callback which is called once the animation completes.
    private var completion: () -> Void
    
    init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }
    
    /// Verifies whether the current animation is finished and calls the completion callback if true.
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }
        
        /// Dispatching is needed to take the next runloop for the completion callback.
        /// This prevents errors like "Modifying state during view update, this will cause undefined behavior."
        DispatchQueue.main.async {
            self.completion()
        }
    }
    
    func body(content: Content) -> some View {
        /// We're not really modifying the view so we can directly return the original input value.
        return content
    }
}
