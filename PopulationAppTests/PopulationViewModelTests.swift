//
//  PopulationViewModel.swift
//  PopulationAppTests
//
//  Created by Muhammad Umair on 24/01/1446 AH.
//
import XCTest
@testable import PopulationApp

final class PopulationViewModelTests: XCTestCase {
    var viewModel: PopulationViewModel!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()

        let mockStateData = [
            PopulationData(regionName: "California", population: 39538223, idRegion: "CA", year: 2024, slugRegion: "california", regionType: .state)
        ]
        mockNetworkManager.mockStateResult = .success(mockStateData)

        let mockNationData = [
            PopulationData(regionName: "United States", population: 331449281, idRegion: "US", year: 2024, slugRegion: "united-states", regionType: .nation)
        ]
        mockNetworkManager.mockNationResult = .success(mockNationData)

        viewModel = PopulationViewModel(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }


    
    
    func testFetchStatePopulationData_EmptyResponse() async {
        mockNetworkManager.mockStateResult = .success([])
        
        await viewModel.fetchData()
        
        XCTAssertEqual(viewModel.populationData.count, 0, "Expected populationData to be empty on empty response")
    }
    
    func testFetchNationPopulationData_EmptyResponse() async {
        mockNetworkManager.mockNationResult = .success([])
        
        await viewModel.fetchData()
        
        XCTAssertEqual(viewModel.populationData.count, 0, "Expected populationData to be empty on empty response")
    }

    
    func testSegmentSwitch_UpdatesSelectedSegment() {
        // Assume initial segment is set to state
        viewModel.selectedSegment = .state
        
        XCTAssertEqual(viewModel.selectedSegment, .state, "Expected initial selected segment to be state")
        
        // Switch to nation segment
        viewModel.selectedSegment = .nation
        
        XCTAssertEqual(viewModel.selectedSegment, .nation, "Expected selected segment to be nation after switch")
        
        // Switch back to state segment
        viewModel.selectedSegment = .state
        
        XCTAssertEqual(viewModel.selectedSegment, .state, "Expected selected segment to be state after switching back")
    }



}
