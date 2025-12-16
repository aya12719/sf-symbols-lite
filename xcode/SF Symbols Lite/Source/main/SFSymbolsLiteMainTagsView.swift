import SwiftUI

struct SFSymbolsLiteMainTagsView: View {

	@Binding var tags: Set<SymbolTag>

	var body: some View {
		VStack {
			Spacer()
			HStack {
				ForEach(Array(tags).sorted(by: { $0.keyword < $1.keyword }), id: \.self) { tag in
					HStack {
						Text("􀋡 " + tag.keyword + " 􀆄")
					}
					.tokenSection(selected: true)
					.shadow(color: .primary.opacity(0.1), radius: 10)
					.onTapGesture {
						_ = tags.remove(tag)
					}
				}
			}
			.frame(height: tags.count == 0 ? 0 : 28)
			.animation(.spring(response: 0.4, dampingFraction: 0.8), value: tags)
		}
		.padding(.bottom, 10)
	}
}
