//
//  TabbarView.swift
//  iQsign
//
//  Created by samara on 23.03.2025.
//  Modified by idk
//

import SwiftUI

struct TabbarView: View {
	@State private var selectedTab: TabEnum = .library

	init() {
		// إخفاء الـ TabBar التقليدي الخاص بالنظام
		UITabBar.appearance().isHidden = true
	}

	var body: some View {
		ZStack(alignment: .bottom) {
			// عرض الشاشة الخاصة بالتبويب المحدد
			TabView(selection: $selectedTab) {
				ForEach(TabEnum.defaultTabs, id: \.hashValue) { tab in
					TabEnum.view(for: tab)
						.tag(tab)
						.toolbar(.hidden, for: .tabBar)
				}
			}
			.ignoresSafeArea(.keyboard, edges: .bottom)

			// 🌟 الشعار الرمزي العائم الدائم في الأعلى (يظهر في كل شاشات التطبيق)
			globalTopOverlay
				.ignoresSafeArea(edges: .top)

			// الشريط السفلي العائم المخصص
			customFloatingTabBar
				.padding(.horizontal, 16)
				.padding(.bottom, 10)
		}
	}

	// MARK: - تصميم الشعار والرموز الدائمة في الأعلى
	private var globalTopOverlay: some View {
		VStack {
			HStack {
				// 1. الجهة اليسرى: صورة غوجو نائم + رقم النسخة والاسم
				HStack(spacing: 6) {
					Image("Kana_love") // صورتك الأولى (غوجو نائم)
						.resizable()
						.scaledToFit()
						.frame(width: 32, height: 32)
						.clipShape(Circle())
						.overlay(Circle().stroke(Color.accentColor.opacity(0.4), lineWidth: 1.5))
					
					VStack(alignment: .leading, spacing: 1) {
						Text("iQsign")
							.font(.system(size: 11, weight: .bold))
							.foregroundColor(.primary)
						Text("v1.0 Mod")
							.font(.system(size: 8, weight: .semibold))
							.foregroundColor(.accentColor)
					}
				}
				.padding(.horizontal, 10)
				.padding(.vertical, 5)
				.background(
					Capsule()
						.fill(.ultraThinMaterial)
						.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
				)
				
				Spacer()
				
				// 2. الجهة اليمنى: صورة غوجو واقف يتلصص (ماركة مسجلة للنسخة)
				HStack {
					Image("Kana_peek") // صورتك الثانية (غوجو متلصص)
						.resizable()
						.scaledToFit()
						.frame(width: 44, height: 44)
				}
				.offset(x: 10, y: -2) // إزاحة خفيفة تخليه يظهر كأنه يتلصص من حافة الشاشة
			}
			.padding(.horizontal, 16)
			.padding(.top, 50) // تعديل المسافة ليتناسب مع نوتش وجزيرة الآيفون العلوية (Safe Area)
			
			Spacer()
		}
		.allowsHitTesting(false) // يضمن عدم حجب اللمس عن أزرار التطبيق العلوية (التمرير والضغط يعمل طبيعي)
	}

	// MARK: - تصميم الشريط العائم
	private var customFloatingTabBar: some View {
		HStack(spacing: 0) {
			ForEach(TabEnum.defaultTabs, id: \.hashValue) { tab in
				let isSelected = selectedTab == tab
				
				Button {
					withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
						selectedTab = tab
					}
				} label: {
					VStack(spacing: 4) {
						Image(systemName: tab.icon)
							.font(.system(size: isSelected ? 20 : 18, weight: isSelected ? .bold : .medium))
							.foregroundColor(isSelected ? .accentColor : .secondary)
							.scaleEffect(isSelected ? 1.15 : 1.0)

						Text(tab.title)
							.font(.system(size: 10, weight: isSelected ? .semibold : .regular))
							.foregroundColor(isSelected ? .accentColor : .secondary)
							.lineLimit(1)
					}
					.frame(maxWidth: .infinity)
					.padding(.vertical, 8)
					.contentShape(Rectangle())
				}
				.buttonStyle(.plain)
			}
		}
		.padding(.horizontal, 8)
		.padding(.vertical, 6)
		.background(
			RoundedRectangle(cornerRadius: 28, style: .continuous)
				.fill(.ultraThinMaterial)
				.shadow(color: Color.black.opacity(0.18), radius: 15, x: 0, y: 7)
				.overlay(
					RoundedRectangle(cornerRadius: 28, style: .continuous)
						.stroke(Color.primary.opacity(0.08), lineWidth: 1)
				)
		)
	}
}
