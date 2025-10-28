// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
  Chronara Digital Estate Network (C.D.E.N)
  A decentralized Estate & Legacy Management contract
  - Based on my original "Will" contract
  - Adds AI-assisted verification simulation
  - Includes document storage
  - Supports NFT-like certificates for real assets
*/

contract ChronaraEstate {
    address owner;
    uint fortune;
    bool deceased;

    constructor () payable {
        owner = msg.sender;
        fortune = msg.value;
        deceased = false;
    }

    // Modifiers
    modifier onlyOwner {
        require (msg.sender == owner, "Only owner allowed");
        _;
    }

    modifier mustBeDeceased {
        require (deceased == true, "Owner still alive");
        _;
    }

    // Data Structures
    struct Beneficiary {
        address payable wallet;
        uint inheritance;
        bool verified;             // AI verification status
        string verificationProof;  // proof data or hash (e.g., IPFS CID)
        uint[] certificateIds;     // IDs of owned certificates
    }

    struct Certificate {
        uint id;
        string assetName;
        string metadata; // could be IPFS CID or data string
        address currentOwner;
    }

    // Storage
    mapping (address => Beneficiary) public beneficiaries;
    address [] public beneficiaryList;

    mapping (uint => Certificate) public certificates;
    uint public totalCertificates;

    mapping (string => string) public legalDocuments; // docTitle => IPFS CID

    // Events
    event BeneficiaryAdded (address indexed wallet, uint amount);
    event BeneficiaryVerified (address indexed wallet, string proof);
    event CertificateIssued (uint id, string asset, address owner);
    event CertificateTransferred (uint id, address from, address to);
    event DocumentStored (string title, string cid);
    event EstateDistributed ();
    event OwnerDeclaredDeceased ();

    // Functions

    // Add or update a beneficiary
    function setBeneficiary (address payable wallet, uint amount) public onlyOwner {
        if (beneficiaries[wallet].wallet == address(0)) {
            beneficiaryList.push(wallet);
        }
        beneficiaries[wallet].wallet = wallet;
        beneficiaries[wallet].inheritance = amount;
        emit BeneficiaryAdded(wallet, amount);
    }

    // Simulated AI verification (manual for now)
    function verifyBeneficiary (address wallet, string memory proofCID) public onlyOwner {
        require (beneficiaries[wallet].wallet != address(0), "Beneficiary not found");
        beneficiaries[wallet].verified = true;
        beneficiaries[wallet].verificationProof = proofCID;
        emit BeneficiaryVerified (wallet, proofCID);
    }

    // Store legal documents (IPFS hash or metadata)
    function storeLegalDocument (string memory title, string memory cid) public onlyOwner {
        legalDocuments[title] = cid;
        emit DocumentStored(title, cid);
    }

    // Create NFT-like ownership certificates
    function issueCertificate(string memory assetName, string memory metadata, address ownerAddr) public onlyOwner {
        totalCertificates++;
        certificates[totalCertificates] = Certificate(totalCertificates, assetName, metadata, ownerAddr);
        beneficiaries[ownerAddr].certificateIds.push(totalCertificates);
        emit CertificateIssued(totalCertificates, assetName, ownerAddr);
    }

    // Transfer a certificate (simple on-chain NFT simulation)
    function transferCertificate(uint certId, address newOwner) public {
        Certificate storage cert = certificates[certId];
        require (msg.sender == cert.currentOwner || msg.sender == owner, "Not authorized");
        address previousOwner = cert.currentOwner;
        cert.currentOwner = newOwner;
        beneficiaries[newOwner].certificateIds.push(certId);
        emit CertificateTransferred(certId, previousOwner, newOwner);
    }

    // Declare deceased (trigger payout)
    function declareDeceased() public onlyOwner {
        deceased = true;
        emit OwnerDeclaredDeceased();
        payout();
    }

    // Pay verified beneficiaries only
    function payout() private mustBeDeceased {
        for (uint i = 0; i < beneficiaryList.length; i++) {
            address payable wallet = beneficiaries[beneficiaryList[i]].wallet;
            uint amount = beneficiaries[wallet].inheritance;
            bool verified = beneficiaries[wallet].verified;

            if (verified && amount > 0) {
                wallet.transfer(amount);
            }
        }
        emit EstateDistributed();
    }

    // View total number of beneficiaries
    function getBeneficiariesCount() public view returns (uint) {
        return beneficiaryList.length;
    }

    // View all certificate IDs owned by a wallet
    function getCertificatesOf(address wallet) public view returns (uint[] memory) {
        return beneficiaries[wallet].certificateIds;
    }

    // Deposit additional ETH into estate
    function deposit() public payable onlyOwner {
        fortune += msg.value;
    }

    // Emergency reclaim before death declaration
    function reclaimFunds() public onlyOwner {
        require(!deceased, "Estate locked");
        payable(owner).transfer(address(this).balance);
    }
}
