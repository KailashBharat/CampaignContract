//SPDX-License-Identifier: MIT
pragma solidity >=0.8.12;        

contract CampaignFactory{
    address[] public deployedCampaigns;

    function createCampaign(uint minimum) public{
        address newCampaign = address(new Campaign(minimum, msg.sender));
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[] memory){
        return deployedCampaigns;
    }
}

contract Campaign{
    struct Request{
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    mapping(uint => Request) public requests;
    uint private requestsIndex = 0;
    uint public approversCount = 0;


    modifier restricted(){
        require(msg.sender == manager);
        _;
    }


    constructor(uint minimum, address creator){
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable{
        require(msg.value >= minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string memory description, uint value, address payable recipient)restricted public{
        Request storage newRequest = requests[requestsIndex];

        newRequest.description = description;
        newRequest.value= value;
        newRequest.recipient= recipient;
        newRequest.complete =false;
        newRequest.approvalCount= 0;
        requestsIndex++;
    }

    function approveRequest(uint index) public{
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvalCount++;
        request.approvals[msg.sender] = true;
    }

    function finalizeRequest(uint index)restricted public{
        Request storage request = requests[index];
        
        require(!request.complete);
        require(request.approvalCount > (approversCount / 2));

        request.recipient.transfer(request.value);
        request.complete = true;
    }


}

