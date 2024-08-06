//
//  AutoSuggestTextField.swift
//  EarthSandwich
//
//  Created by Duc on 7/8/24.
//

import CoreLocation
import SwiftUI
import UIKit
import W3WSwiftApi
import W3WSwiftComponents

struct AutoSuggestTextField: UIViewRepresentable {
    typealias UIViewType = UIView

    var locale: String
    var countryCode: String
    @Binding var text: String
    @Binding var focusing: Bool

    func makeUIView(context: Context) -> UIViewType {
        let textField = W3WAutoSuggestTextField()
        textField.font = .systemFont(ofSize: 28)
        let options = W3WOptions()
            .clip(to: W3WBaseCountry(code: countryCode))
            .focus(CLLocationCoordinate2D(latitude: 50.0, longitude: 0.1))
            .language(W3WBaseLanguage(locale: locale))
        textField.set(options: options)
        textField.textChanged = { text in
            debugPrint("TEXT: ", text ?? "none")
            context.coordinator.textChanged(text ?? "")
        }
        textField.addTarget(context.coordinator, action: #selector(Coordinator.editingDidBegin), for: .editingDidBegin)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.editingDidEnd), for: .editingDidEnd)
        textField.set(NetworkW3WWorker().api)
        let view = UIView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.topAnchor.constraint(equalTo: view.topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        (uiView.subviews.first as? W3WAutoSuggestTextField)?.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, focusing: $focusing)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var focusing: Binding<Bool>

        init(text: Binding<String>, focusing: Binding<Bool>) {
            self.text = text
            self.focusing = focusing
        }

        @objc func textChanged(_ text: String) {
            self.text.wrappedValue = text
        }

        @objc func editingDidBegin(_ textField: UITextField) {
//            text.wrappedValue = ""
            focusing.wrappedValue = true
        }

        @objc func editingDidEnd(_ textField: UITextField) {
//            text.wrappedValue = textField.text ?? ""
            focusing.wrappedValue = false
        }
    }
}
