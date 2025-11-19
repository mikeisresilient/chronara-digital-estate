

# **Chronara Digital Estate Network (C.D.E.N)**

A Decentralized Estate and Legacy Management Smart Contract
Built on Ethereum

---

## **Overview**

Chronara Digital Estate Network (C D E N) is an on chain estate and legacy management system that automates inheritance distribution, manages legal documents, and issues NFT like certificates that represent real world or digital assets.

This contract extends its capability with AI assisted identity verification simulation, document storage, certificate ownership tracking, and programmed distribution of inheritance.

The goal is to provide trustless estate execution without legal loopholes or corruption.

---

## **Core Features**

### **1. Decentralized Estate Distribution**

The owner deposits ETH into the contract.
ETH is automatically distributed to beneficiaries after the owner is declared deceased.

### **2. Beneficiary Management**

The owner can:

* Add beneficiaries
* Set inheritance amounts
* Update beneficiary info

Each beneficiary contains:

* Wallet
* Inheritance amount
* Verification status
* Proof data or IPFS CID
* List of certificates they own

---

## **3. AI Assisted Beneficiary Verification (Simulated)**

The contract simulates future AI verification using a manual input mechanism.

The owner can verify a beneficiary by submitting a proof or IPFS hash.

---

## **4. Certificate System (NFT Style)**

C D E N allows the owner to issue digital certificates representing assets.

Each certificate stores:

* Unique ID
* Asset name
* Metadata or IPFS CID
* Current owner

Certificates can be transferred between users, similar to NFTs.

---

## **5. Legal Document Storage**

The owner can store IPFS documents or metadata related to:

* Property deeds
* Legal documents
* Identity proofs
* Final wishes

Documents are stored as title to CID pairs.

---

## **6. Trustless Payout After Death**

Once the owner triggers `declareDeceased`, the contract:

1. Locks the estate
2. Pays only verified beneficiaries
3. Emits an event for transparent record keeping

---

## **7. Emergency Options**

Before death:

* The owner can reclaim estate funds
* The owner can add more ETH

After death:

* Estate is locked and paid out automatically

---

## **Contract Functions Summary**

### **Owner Functions**

* `setBeneficiary(address, amount)`
* `verifyBeneficiary(address, proofCID)`
* `storeLegalDocument(title, cid)`
* `issueCertificate(assetName, metadata, owner)`
* `declareDeceased()`
* `deposit()`
* `reclaimFunds()`

---

### **Public Functions**

* `transferCertificate(certId, newOwner)`
* `getBeneficiariesCount()`
* `getCertificatesOf(wallet)`

---

### **Internal Functions**

* `payout()`
  Automatically sends ETH to verified beneficiaries.

---

## **Events**

* `BeneficiaryAdded`
* `BeneficiaryVerified`
* `CertificateIssued`
* `CertificateTransferred`
* `DocumentStored`
* `OwnerDeclaredDeceased`
* `EstateDistributed`

Events allow complete transparency for auditing and tracking.

---

## **Deployment**

To deploy on Remix:

1. Open Remix and create a new Solidity file.
2. Paste the contract code.
3. Compile with Solidity version 0.8.0 or higher.
4. In Deploy settings select a value for the constructor (ETH for initial fortune).
5. Deploy.

---

## **Usage Flow**

1. Deploy the contract with initial estate value
2. Add beneficiaries
3. Verify beneficiaries by uploading proof hash
4. Issue certificates that represent assets
5. Upload important legal documents via IPFS
6. When ready, the owner calls `declareDeceased`
7. Contract automatically distributes funds

---

## **Security Notes**

* Only the owner can modify estate details
* Estate becomes immutable after death
* Funds cannot be claimed by unverified beneficiaries
* Certificates cannot be transferred by unauthorised users

---

## **Future Expansions**

Planned upgrades for C D E N:

* Real AI verification integration
* ERC 721 certificate upgrade
* DAO governance for estate disputes
* Time locked death declaration
* Multi signature verification
  
