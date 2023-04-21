// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    //we create a struct for the crowdfunding details
    // this is like an object
    struct Campaign {
        address owner; // this is the owner
        string title; // title of the campaign
        string description; // the decription of the ccampaign
        uint256 target; // the goal or the money intended to raise from the campaign
        uint256 deadline; // the ending time for the campaign
        uint256 amountCollected; //total amount collected
        string image;
        address[] donators; //the array of donators
        uint256[] donations; //the array of donations
    }

    mapping(uint256 => Campaign) public campaigns;

    //initialize the number of campaign to zero
    uint256 public numberOfCampaigns = 0;

    constructor() {}

    //this function creates campaign
    //@dev params
    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Campaign storage newcampaign = campaigns[numberOfCampaigns];
        require(
            newcampaign.deadline < block.timestamp,
            "should be a date in the future"
        );

        newcampaign.owner = _owner;
        newcampaign.title = _title;
        newcampaign.description = _description;
        newcampaign.deadline = _deadline;
        newcampaign.amountCollected = 0;
        newcampaign.image = _image;

        //increment the number of campaign
        numberOfCampaigns++;
        // return the most created campaign
        return numberOfCampaigns - 1;
    }

    //this function is used to donate to a particular campaign
    //@params this is the id of the campaign we will be
    //          donating money to.
    function donateToCampaign(uint _id) public payable {
        uint256 amount = msg.value;

        //get the particular campain with id
        Campaign storage campaign = campaigns[_id];

        //push the sender to the array of donators
        campaign.donators.push(msg.sender);
        //push the money the sender sent into the doantions array
        campaign.donations.push(msg.value);

        //send the amount donated to the owner of the particular campaign
        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        //increment the amount collected for the particular campaign
        if (sent) {
            campaign.amountCollected += amount;
        }
    }

    //this is use to get the donors to a particular campaign
    function getDonors(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    //this is used to get the campaign index
    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaign = new Campaign[](numberOfCampaigns);
        for (uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaign[i] = item;
        }
        return allCampaign;
    }
}
