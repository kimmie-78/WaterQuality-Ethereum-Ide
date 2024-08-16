// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WaterQuality {
    struct WaterQualityData {
        string area;
        uint256 solids;
        uint256 hardness;
        uint256 pH;
        uint256 sulfate;
        uint256 chloramines;
        uint256 organicCarbon;
        uint256 trihalomethanes;
        uint256 conductivity;
        int256 potability;
        string additionalNotes;
        //turbidity has been removed, because there was an error
    }

    mapping(string => WaterQualityData[]) public areaData;

    event DataRecorded(string area, uint256 solids, uint256 hardness, uint256 pH, uint256 sulfate, uint256 chloramines, uint256 organicCarbon, uint256 trihalomethanes, uint256 conductivity, int256 potability, string additionalNotes);
    event PaymentReceived(address indexed sender, uint amount);

    function recordData(
        string memory area,
        uint256 solids,
        uint256 hardness,
        uint256 pH,
        uint256 sulfate,
        uint256 chloramines,
        uint256 organicCarbon,
        uint256 trihalomethanes,
        uint256 conductivity,
        int256 potability,
        string memory additionalNotes
    ) public {
        _storeData(area, solids, hardness, pH, sulfate, chloramines, organicCarbon, trihalomethanes, conductivity, potability, additionalNotes);
    }

    function _storeData(
        string memory area,
        uint256 solids,
        uint256 hardness,
        uint256 pH,
        uint256 sulfate,
        uint256 chloramines,
        uint256 organicCarbon,
        uint256 trihalomethanes,
        uint256 conductivity,
        int256 potability,
        string memory additionalNotes
    ) internal {
        WaterQualityData memory newData = WaterQualityData({
            area: area,
            solids: solids,
            hardness: hardness,
            pH: pH,
            sulfate: sulfate,
            chloramines: chloramines,
            organicCarbon: organicCarbon,
            trihalomethanes: trihalomethanes,
            conductivity: conductivity,
            potability: potability,
            additionalNotes: additionalNotes
        });
        areaData[area].push(newData);
        emit DataRecorded(area, solids, hardness, pH, sulfate, chloramines, organicCarbon, trihalomethanes, conductivity, potability, additionalNotes);
    }

    function getDataByArea(string memory area) public view returns (WaterQualityData[] memory) {
        return areaData[area];
    }

    function getLatestDataByArea(string memory area) public view returns (WaterQualityData memory) {
        require(areaData[area].length > 0, "No data available for this area!");
        return areaData[area][areaData[area].length - 1];
    }

    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    fallback() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    function withdraw() public {
        require(address(this).balance > 0, "No balance to withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }

    function recordDataWithPayment(
        string memory area,
        uint256 solids,
        uint256 hardness,
        uint256 pH,
        uint256 sulfate,
        uint256 chloramines,
        uint256 organicCarbon,
        uint256 trihalomethanes,
        uint256 conductivity,
        int256 potability,
        string memory additionalNotes
    ) public payable {
        require(msg.value > 0, "Payment required");

        _storeData(area, solids, hardness, pH, sulfate, chloramines, organicCarbon, trihalomethanes, conductivity, potability, additionalNotes);
        emit PaymentReceived(msg.sender, msg.value);
    }
}
