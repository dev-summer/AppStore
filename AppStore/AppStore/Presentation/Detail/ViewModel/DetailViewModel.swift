//
//  DetailViewModel.swift
//  AppStore
//
//  Created by summercat on 2023/07/17.
//

final class DetailViewModel {
    let app: App
    private(set) var items: [(section: DetailSection, item: DetailItem)] = []
    
    init(app: App) {
        self.app = app
        appendItems()
    }
    
    private func appendItems() {
        appendTopItem()
        appendSummaryItems()
        appendScreenshotItems()
        appendDescriptionItem()
        appendReleaseNotesItem()
        appendInformationItemModel()
    }
    
    private func appendTopItem() {
        let topItem = DetailTopItem(app: app)
        items.append((section: .top, item: .top(topItem)))
    }
    
    private func appendSummaryItems() {
        let summaryItems: [DetailSummaryItem] = [
            DetailSummaryItem(
                topLabelText: app.userRatingCount.shortenedText + " RATINGS",
                middleLabelText: String(format: "%.1f", app.averageUserRating),
                bottomLabelText: nil,
                type: .ratings
            ),
            DetailSummaryItem(
                topLabelText: "AGE",
                middleLabelText: app.contentAdvisoryRating,
                bottomLabelText: "Years Old",
                type: .age
            ),
            DetailSummaryItem(
                topLabelText: "DEVELOPER",
                middleLabelText: nil,
                bottomLabelText: app.developerName,
                type: .developer
            ),
            DetailSummaryItem(
                topLabelText: "LANGUAGE",
                middleLabelText: app.languageCodesISO2A.first,
                bottomLabelText: (app.languageCodesISO2A.count - 1).languageCodeCount,
                type: .language
            )
        ]
        summaryItems.forEach { items.append((section: .summary, item: .summary($0))) }
    }
    
    private func appendScreenshotItems() {
        let screenshotItems: [DetailScreenshotItem] = app.screenshotURLs.map { DetailScreenshotItem(screenshotURL: $0) }
        screenshotItems.forEach { items.append((section: .screenshot, item: .screenshot($0))) }
    }
    
    private func appendDescriptionItem() {
        let descriptionItem = DetailDescriptionItem(description: app.description)
        items.append((section: .description, item: .description(descriptionItem)))
    }
    
    private func appendReleaseNotesItem() {
        guard let releaseNotes = app.releaseNotes,
              releaseNotes != "" else { return }
        let releaseNotesItem = DetailReleaseNotesItem(currentVersion: app.version, releaseNotes: releaseNotes)
        items.append((section: .releaseNote, item: .releaseNote(releaseNotesItem)))
    }
    
    private func appendInformationItemModel() {
        let informationItems: [DetailInformationItem] = [
            DetailInformationItem(itemName: "Provider", itemInformation: app.providerName),
            DetailInformationItem(itemName: "Size", itemInformation: app.fileSizeBytes),
            DetailInformationItem(itemName: "Category", itemInformation: app.appCategory),
            DetailInformationItem(itemName: "Compatibility", itemInformation: app.minimumOSVersion)
        ]
        informationItems.forEach { items.append((section: .information, item: .information($0))) }
    }
}
