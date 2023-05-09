# Electronic Voting Smart Contract

This Solidity smart contract is designed for conducting electronic voting with the following features:

1. Ability to add and remove candidates
2. Ability to add and remove voters
3. Authentication of voters before allowing them to vote
4. Weighted voting based on the voter's weight
5. Restriction of the maximum number of votes a candidate can receive
6. Election start and end times to ensure that voting only takes place during the specified time frame
7. Determination of the winner of the election after voting has ended

## Getting Started

To use this smart contract, you will need to have a development environment set up for Solidity development. This can include tools like Remix IDE, Truffle, or Hardhat.

### Prerequisites

- Solidity development environment
- Ethereum wallet (e.g. Metamask)

### Installing

1. Clone this repository to your local machine
2. Open the contract file in your Solidity development environment
3. Compile the contract
4. Deploy the contract to your Ethereum network of choice

## Usage

### Adding Candidates

To add a candidate, call the `addCandidate` function with the candidate's name as the parameter. Only the contract owner can add and remove candidates.

### Removing Candidates

To remove a candidate, call the `removeCandidate` function with the candidate's name as the parameter. Only the contract owner can add and remove candidates.

### Adding Voters

To add a voter, call the `addVoter` function with the voter's Ethereum address and weight as the parameters. Only the contract owner can add and remove voters.

### Removing Voters

To remove a voter, call the `removeVoter` function with the voter's Ethereum address as the parameter. Only the contract owner can add and remove voters.

### Authenticating Voters

Before a voter can cast their vote, they must authenticate their identity by calling the `authenticate` function. This will set the `authenticated` flag for the voter, indicating that they are authorized to vote.

### Casting Votes

To cast a vote, call the `castVote` function with the name of the candidate as the parameter. The voter must be authorized, authenticated, and have not yet cast their vote. Additionally, the election must be open and the candidate must not have received the maximum number of votes.

### Setting Election Time

To set the start and end times for the election, call the `setElectionTime` function with the start and end times as parameters. Only the contract owner can set the election time.

### Determining the Winner

After the election has ended, call the `getWinner` function to determine the winner of the election.
