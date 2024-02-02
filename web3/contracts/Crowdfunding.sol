// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Crowdfunding {
    struct Campaign{
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping (uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns =0;

    function createCampaign(address _owner, string memory _title, string memory _description,
    uint256 _target, uint256 _deadline, string memory _image) 
    public returns (uint256)  {
        Campaign storage campaign = campaigns[numberOfCampaigns];  

        require(campaign.deadline < block.timestamp, "Deadline should be in future");

        campaign.owner = _owner;
        campaign.title = _title;        
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;  //initially
        campaign.image = _image;

        numberOfCampaigns++;  //incrementing the numbewr of campaign if created

        return numberOfCampaigns -1;
    }

    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];  //here id is getting stored

        campaign.donators.push(msg.sender);         //address of hte person donated
        campaign.donations.push(amount);         //amount that is paid to the campaign
        // confirmation wether amount has been sent or not
        (bool sent,)  = payable (campaign.owner).call{value: amount}("");

        if(sent){
            //adding the donated amount to existing amount
            campaign.amountCollected = campaign.amountCollected + amount; 
        }
                                                     
    }

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory){
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i=0; i<numberOfCampaigns ; i++){
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;

            return allCampaigns;
        }
    }
}