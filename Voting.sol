// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Voting {
    // Structure for storing voter information
    struct Voter {
        bool authenticated; // Has the voter authenticated their identity?
        bool voted; // Has the voter cast their vote?
        uint256 weight; // Weight of the voter's vote (for weighted voting)
    }

    // Structure for storing candidate information
    struct Candidate {
        string name; // Name of the candidate
        uint256 voteCount; // Number of votes the candidate has received
    }

    // Address of the contract owner (admin)
    address public owner;

    // List of candidate addresses and candidate data
    address[] public candidateList;
    mapping(address => Candidate) public candidates;

    // List of voter addresses and voter data
    address[] public voterList;
    mapping(address => Voter) public voters;

    // Minimum number of votes required for the election to be valid
    uint256 public threshold;

    // Election start and end times
    uint256 public startTime;
    uint256 public endTime;

    // Event that is emitted when a voter is authenticated
    event VoterAuthenticated(address voter);

    // Event that is emitted when a voter casts their vote
    event VoteCast(address voter, address candidate);

    // Constructor function that sets the owner and threshold
    constructor(uint256 _threshold) {
        owner = msg.sender;
        threshold = _threshold;
    }

    // Modifier function that restricts access to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Function for adding a candidate
    function addCandidate(address _candidate, string memory _name) public onlyOwner {
        candidates[_candidate] = Candidate({
            name: _name,
            voteCount: 0
        });
        candidateList.push(_candidate);
    }

    // Function for removing a candidate
    function removeCandidate(address _candidate) public onlyOwner {
        delete candidates[_candidate];
        for (uint256 i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == _candidate) {
                candidateList[i] = candidateList[candidateList.length - 1];
                candidateList.pop();
                break;
            }
        }
    }

    // Function for adding a voter
    function addVoter(address _voter, uint256 _weight) public onlyOwner {
        voters[_voter] = Voter({
            authenticated: false,
            voted: false,
            weight: _weight
        });
        voterList.push(_voter);
    }

    // Function for removing a voter
    function removeVoter(address _voter) public onlyOwner {
        delete voters[_voter];
        for (uint256 i = 0; i < voterList.length; i++) {
            if (voterList[i] == _voter) {
                voterList[i] = voterList[voterList.length - 1];
                voterList.pop();
                break;
            }
        }
    }

    // Function for authenticating a voter
    function authenticateVoter() public {
        Voter storage voter = voters[msg.sender];
        require(voter.weight > 0, "You are not authorized to vote");
        require(!voter.authenticated, "You have already authenticated your identity");
        voter.authenticated = true;
        emit VoterAuthenticated(msg.sender);
    }

    // Function for casting a vote
    function castVote(address _candidate) public {
    Voter storage voter = voters[msg.sender];
    require(voter.weight > 0, "You are not authorized to vote");
    require(voter.authenticated, "You must authenticate your identity before voting");
    require(!voter.voted, "You have already cast your vote");
    require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is not currently open");
    require(candidates[_candidate].voteCount < threshold, "This candidate has reached the maximum number of votes");
    voter.voted = true;
    candidates[_candidate].voteCount += voter.weight;
    emit VoteCast(msg.sender, _candidate);
}

// Function for setting the start and end times of the election
function setElectionTime(uint256 _startTime, uint256 _endTime) public onlyOwner {
    require(_endTime > _startTime, "End time must be after start time");
    startTime = _startTime;
    endTime = _endTime;
}

// Function for getting the winner of the election
function getWinner() public view returns (string memory) {
    require(block.timestamp > endTime, "Election is still ongoing");
    uint256 maxVotes = 0;
    address winningCandidate;
    for (uint256 i = 0; i < candidateList.length; i++) {
        if (candidates[candidateList[i]].voteCount > maxVotes) {
            maxVotes = candidates[candidateList[i]].voteCount;
            winningCandidate = candidateList[i];
        }
    }
    return candidates[winningCandidate].name;
}
}