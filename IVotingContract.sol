// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


interface IVotingContract{

//only one address should be able to add candidates
    function addCandidate(string memory candidateName) external returns(bool);


    function voteCandidate(uint candidateId) external returns(bool);

    //getWinner returns the name of the winner
    function getWinner() external returns(string memory winnerName_);
}