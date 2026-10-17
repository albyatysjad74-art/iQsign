//
//  AboutView.swift
//  iQsign
//
//  Created by samara on 30.04.2025.
//  Modified by idk
//

import SwiftUI
import NimbleViews

// MARK: - View
struct AboutView: View {
	private let channelImage = URL(string: "https://i.postimg.cc/c6qM6ZW3/B51B3BF4-48C5-4177-88D3-329B5DB7AF79.jpg")!
	private let devImage = URL(string: "https://i.postimg.cc/Bvhzb8VK/4B052995-278C-4F0C-960C-3DC02AB33E44.jpg")!

	// MARK: Body
	var body: some View {
		NBList("iQsign") {
			// قسم شرح التطبيق
			NBSection("عن التطبيق") {
				VStack(alignment: .leading, spacing: 8) {
					HStack(spacing: 12) {
						Image(systemName: "signature")
							.font(.system(size: 30, weight: .bold))
							.foregroundStyle(.tint)
						
						VStack(alignment: .leading, spacing: 2) {
							Text("iQsign")
								.font(.headline)
							Text("تطبيق توقيع وإدارة تطبيقات iOS")
								.font(.subheadline)
								.foregroundStyle(.secondary)
						}
					}
					.padding(.vertical, 4)
					
					Text("أداة متكاملة لتوقيع ملفات الـ IPA وتثبيتها بشكل مباشر، مع إمكانية إدارة الشهادات، وحقن ملفات الـ dylib، وإضافة المتاجر والسورسات الخارجية.")
						.font(.footnote)
						.foregroundStyle(.secondary)
				}
				.padding(.vertical, 4)
			}
			
			// قسم حساب المطور
			NBSection("المطور الرسمي") {
				_customLinkCell(
					title: "idk",
					subtitle: "المطور الأساسي (@x_arw)",
					imageUrl: devImage,
					urlString: "https://t.me/x_arw"
				)
			}
			
			// قسم القنوات والدعم الفني
			NBSection("القنوات والدعم الفني") {
				_customLinkCell(
					title: "قناة التليجرام الرسمية",
					subtitle: "@xar_ipa",
					imageUrl: channelImage,
					urlString: "https://t.me/xar_ipa"
				)
				
				_customLinkCell(
					title: "قناة حل المشاكل والدعم",
					subtitle: "@xar_ipa1",
					imageUrl: channelImage,
					urlString: "https://t.me/xar_ipa1"
				)
			}

			// قسم الخدمات والشهادات
			NBSection("خدمات إضافية") {
				HStack(alignment: .top, spacing: 12) {
					Image(systemName: "checkmark.seal.fill")
						.font(.title3)
						.foregroundStyle(.green)
						.padding(.top, 2)
					
					VStack(alignment: .leading, spacing: 4) {
						Text("شهادات سنوية ومدفوعة")
							.font(.subheadline.bold())
						Text("يتوفر لدى المطور اشتراكات وشهادات سنوية ومدفوعة ومضمونة لتثبيت التطبيقات دون توقف. للتواصل والاستفسار عبر حساب المطور.")
							.font(.caption)
							.foregroundStyle(.secondary)
					}
				}
				.padding(.vertical, 4)
			}
		}
	}
}

// MARK: - Extension: Custom Cell
extension AboutView {
	@ViewBuilder
	private func _customLinkCell(
		title: String,
		subtitle: String,
		imageUrl: URL,
		urlString: String
	) -> some View {
		FRIconCellView(
			title: title,
			subtitle: subtitle,
			iconUrl: imageUrl,
			trailing: AnyView(
				Image(systemName: "arrow.up.right")
					.foregroundStyle(.secondary)
			)
		)
		.onTapGesture {
			if let url = URL(string: urlString) {
				UIApplication.shared.open(url)
			}
		}
	}
}
