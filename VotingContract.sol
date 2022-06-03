// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IVotingContract.sol";


contract VotingContract is IVotingContract{

    address public inec;
    uint private start;

    struct Voter {
        bool voted;  // if true, that person already voted
    }

    struct Candidate {
        string name;   // short name (up to 32 bytes)
        uint voteCount; // number of votes
        uint candidateId;
    }

    mapping(address => Voter) public voters;

    Candidate[] public candidates;


    constructor(){
        inec = msg.sender;
        start = block.timestamp;
    }

    function addCandidate(string memory candidateName) override external returns(bool){
        require(msg.sender == inec, "Only inec can register candidates");
        require(block.timestamp - start <= 180, "Registration of candidates is over");

        candidates.push(Candidate({
            name: candidateName,
            voteCount: 0,
            candidateId: candidates.length
        }));

        return true;
    }

    function getCandidates() external view returns(Candidate[] memory ){
        return candidates;
    }


    function voteCandidate(uint candidateId) override external returns(bool){
        require(block.timestamp - start > 180, "Registration of candidates is still ongoing");
        require(block.timestamp - start <= 360, "Voting is over");
        require(candidates.length > 0, "No candidate has been registered");
        require(candidateId <= candidates.length, "Candidate does not exist");

        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You have already voted.");
        sender.voted = true;


        candidates[candidateId].voteCount += 1;

        return sender.voted;

    }

    function winningCandidateId() public view
            returns (uint winningCandidate_){
        uint winningVoteCount = 0;
        for (uint p = 0; p < candidates.length; p++) {
            if (candidates[p].voteCount > winningVoteCount) {
                winningVoteCount = candidates[p].voteCount;
                winningCandidate_ = p;
            }
        }
    }

    //getWinner returns the name of the winner
    function getWinner() override external view returns(string memory winnerName_){
        require(block.timestamp - start > 360, "Voting is still on");

        winnerName_  = candidates[winningCandidateId()].name;
    }

}