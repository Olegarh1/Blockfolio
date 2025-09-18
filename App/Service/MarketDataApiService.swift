import Foundation
import Combine

class MarketDataApiService {
    @Published var allCoins: [Coin] = []
    @Published var lastUpdated = ""
    
    private let decoder: JSONDecoder
    
    // Store subscribers
    private var subscribers = Set<AnyCancellable>()
    
    init() {
        // Setup decoder with custom date parsing logic
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(GeneralUtility.lastUpdatedDateFormatter)
        
        getAllCoins()
    }
    
    // Updates published coin data
    func getAllCoins() {
        guard let url = URL(string: GeneralUtility.serverBaseUrl + "/api/v3/coins/markets?vs_currency=usd") else { return }
        
        NetworkingManager.download(url: url)
            .decode(type: [Coin].self, decoder: decoder)
            // Switch from background thread to main thread
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    print("❌ MarketDataApiService Network / Decoding error: \(error)")
                    return
                case .finished:
                    print("✅ MarketDataApiService Request finished successfully")
                    break
                }
            }, receiveValue: { [weak self] container in
                print("MarketDataApiService Full response: \(container)")
                self?.allCoins = container
//                self?.lastUpdated = container.lastUpdated?.asFormattedDate(dateType: .lastUpdated) ?? ""
            })
            .store(in: &subscribers)
    }
}
