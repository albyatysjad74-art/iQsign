//
//  SigningAppPropertiesView.swift
//  Feather
//
//  Created by samara on 17.04.2025.
//  Modified for iQsign
//

import SwiftUI
import NimbleViews

// MARK: - View
struct SigningPropertiesView: View {
	@Environment(\.dismiss) var dismiss
	
	@State private var text: String = ""
	
	var saveButtonDisabled: Bool {
		text == initialValue
	}
	
	var title: String
	var initialValue: String 
	var certAppId: String? = nil
	@Binding var bindingValue: String?
	
	// MARK: Body
	var body: some View {
        NBList(title) {
            TextField(initialValue, text: $text)
                .textInputAutocapitalization(.none)
            
            // 🌟 قسم ميزة تكرار التطبيق تلقائياً (خاص بـ iQsign)
            Section {
                Button {
                    // إذا كان الحقل هو لتعديل البندل آيدي
                    if text.contains(".") {
                        if !text.hasSuffix(".clone2") {
                            text = "\(text).clone2"
                        }
                    } else {
                        // إذا كان الحقل هو اسم التطبيق
                        if !text.hasSuffix(" 2") {
                            text = "\(text) 2"
                        }
                    }
                } label: {
                    Label("تكرار كنسخة ثانية (تلقائي)", systemImage: "square.on.square.badge.person.crop")
                        .foregroundColor(.accentColor)
                }
                
                // زر استرجاع القيمة الأصلية
                if text != initialValue {
                    Button(role: .destructive) {
                        text = initialValue
                    } label: {
                        Label("استعادة القيمة الأصلية", systemImage: "arrow.uturn.backward")
                    }
                }
            } footer: {
                Text("يقوم تلقائياً بتغيير البندل أو إضافة رقم 2 للاسم لتثبيته بجانب التطبيق الأصلي كنسخة ثانية.")
                    .font(.caption)
            }
            
            if certAppId != nil {
                Section {
                    Button {
                        text = certAppId ?? ""
                    } label: {
                        Text(.localized("Matching Certificate's App ID"))
                    }
                    .disabled(certAppId == nil)
                } footer: {
                    Text(.localized("Use certiticate's app ID, this will help the app have access to features that uses certificate's entitlements."))
                }
            }
        }
		.toolbar {
			NBToolbarButton(
				.localized("Save"),
				style: .text,
				placement: .topBarTrailing,
				isDisabled: saveButtonDisabled
			) {
				if !saveButtonDisabled {
					bindingValue = text
					dismiss()
				}
			}
		}
		.onAppear {
			text = initialValue
		}
	}
}
