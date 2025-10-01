//
// BlockfolioTests.swift
// Blockfolio
//
// Created by Oleg Zakladnyi on 01.10.2025

import XCTest
import Combine
@testable import Blockfolio

import Testing

struct BlockfolioTests {
    
    var cancellables = Set<AnyCancellable>()
    
    @Test func getAllCoins_success() async throws {
        // given
        let coins = [Coin(id: "bitcoin", symbol: "btc", name: "Bitcoin")]
        let data = try JSONEncoder().encode(coins)
        NetworkingManagerMock.testData = data
        NetworkingManagerMock.shouldFail = false
        
        let sut = MarketDataApiService(networking: NetworkingManagerMock.self)
        
        // when
        let result = try await sut.$allCoins
            .dropFirst() // перший емісія — пустий масив
            .firstValue()
        
        // then
        #expect(result.count == 1)
        #expect(result.first?.id == "bitcoin")
    }
    
    @Test func getAllCoins_failure() async throws {
        // given
        NetworkingManagerMock.shouldFail = true
        NetworkingManagerMock.testData = nil
        
        let sut = MarketDataApiService(networking: NetworkingManagerMock.self)
        
        // when
        let result = try await sut.$allCoins
            .firstValue()
        
        // then
        #expect(result.isEmpty)
    }
    
    // MARK: - Porfoli tests
    
    @Test func getManagedCoins_emptyInitially() async throws {
        // given
        let sut = ManagedDataService(inMemory: true)
        let portfolio = Portfolio(context: sut.context)
        portfolio.portfolioId = "p1"
        sut.portfolios = [portfolio]
        
        // when
        let coins = sut.getManagedCoins(portfolioId: "p1")
        
        // then
        #expect(coins.isEmpty)
    }
    
    @Test func updateCoin_createsNewCoin() async throws {
        // given
        let sut = ManagedDataService(inMemory: true)
        let portfolio = Portfolio(context: sut.context)
        portfolio.portfolioId = "p1"
        sut.portfolios = [portfolio]
        
        let coin = Coin(id: "bitcoin", symbol: "BTC", name: "Bitcoin")
        
        // when
        sut.updateCoin(
            portfolioId: "p1",
            coin: coin,
            holdingAmount: 1.0,
            costBasis: 20000,
            isWatched: true,
            selectedCoinNote: "note"
        )
        
        // then
        let coins = sut.getManagedCoins(portfolioId: "p1")
        #expect(coins.count == 1)
        #expect(coins.first?.id == "bitcoin")
        #expect(coins.first?.holdingAmount == 1.0)
        #expect(coins.first?.costBasis == 20000)
        #expect(coins.first?.isWatched == true)
        #expect(coins.first?.portfolio == portfolio) // перевірка зв’язку
    }
    
    @Test func updateCoin_updatesExistingCoin() async throws {
        // given
        let sut = ManagedDataService(inMemory: true)
        let portfolio = Portfolio(context: sut.context)
        portfolio.portfolioId = "p1"
        
        let managedCoin = ManagedCoin(context: sut.context)
        managedCoin.id = "bitcoin"
        managedCoin.holdingAmount = 1.0
        managedCoin.costBasis = 20000
        managedCoin.isWatched = true
        managedCoin.portfolio = portfolio
        portfolio.addToManagedCoins(managedCoin)
        
        sut.portfolios = [portfolio]
        
        let coin = Coin(id: "bitcoin", symbol: "BTC", name: "Bitcoin")
        
        // when
        sut.updateCoin(
            portfolioId: "p1",
            coin: coin,
            holdingAmount: 2.0,
            costBasis: 25000,
            isWatched: false,
            selectedCoinNote: "updated"
        )
        
        // then
        let coins = sut.getManagedCoins(portfolioId: "p1")
        #expect(coins.count == 1)
        #expect(coins.first?.holdingAmount == 2.0)
        #expect(coins.first?.costBasis == 25000)
        #expect(coins.first?.isWatched == false)
        #expect(coins.first?.portfolio == portfolio)
    }
    
    @Test func deleteCoin_removesCoin() async throws {
        // given
        let sut = ManagedDataService(inMemory: true)
        let portfolio = Portfolio(context: sut.context)
        portfolio.portfolioId = "p1"
        
        let managedCoin = ManagedCoin(context: sut.context)
        managedCoin.id = "bitcoin"
        managedCoin.portfolio = portfolio
        portfolio.addToManagedCoins(managedCoin)
        
        sut.portfolios = [portfolio]
        
        let coin = Coin(id: "bitcoin", symbol: "BTC", name: "Bitcoin")
        
        // when
        sut.deleteCoin(portfolioId: "p1", coin: coin)
        
        // then
        let coins = sut.getManagedCoins(portfolioId: "p1")
        #expect(coins.isEmpty)
    }
    
    @Test func updatePortfolioName_changesName() async throws {
        // given
        let sut = ManagedDataService(inMemory: true)
        let portfolio = Portfolio(context: sut.context)
        portfolio.portfolioId = "p1"
        portfolio.portfolioName = "Old Name"
        sut.portfolios = [portfolio]
        
        // when
        sut.updatePortfolioName(portfolioId: "p1", updatedName: "New Name")
        
        // then
        #expect(sut.portfolios.first?.portfolioName == "New Name")
    }
    
    @Test func createAndDeletePortfolio() async throws {
        // given
        let sut = ManagedDataService(inMemory: true)
        
        // when
        sut.createPortfolio(portfolioId: "100", name: "Test Portfolio")
        
        // then
        let created = sut.portfolios.first { $0.portfolioId == "100" }
        #expect(created != nil)
        #expect(created?.portfolioName == "Test Portfolio")
        
        // when delete
        sut.deletePortfolio(portfolioId: "100")
        let deleted = sut.portfolios.first { $0.portfolioId == "100" }
        #expect(deleted == nil)
    }
}
