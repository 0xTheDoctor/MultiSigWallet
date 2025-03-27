// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract multiSig {
    address[] public owners;
    uint public confirmationRequired;

    struct Transaction{
        address to; uint value; bool isExecuted;
    }

    mapping(uint=>mapping(address=>bool)) isConfirmed;
    Transaction[] public transactions;

    event TransactionSubmitted(uint transactionId, address sender, address reciever, uint amount);
    event TransactionConfirmed(uint transactionId);

    constructor(address[] memory _owners, uint _confirmationRequired){
        require(_owners.length>=1,"Must have atleast 2 owners.");
        require(_confirmationRequired>0 && _confirmationRequired<=_owners.length-1,"not in sync with owners");

        for(uint i=0;i<_owners.length;;i++){
            require(_owners[i]!=address(0),"Addresses cannot be 0x0.");
            owners.push(_owners[i]);
        }
        confirmationRequired = _confirmationRequired;
    }

    function submitTransactions(address _to)public payable{
        require(_to!=0),"Address cannot be 0x0.";
        require(msg.value>=1 ether,"Must send at least one Ether.";)

        uint transactionId = transactions.length;
        transactions.push(Transaction{{_to, msg.value(),false;}})
        emit TransactionSubmitted(transactionId, msg.ender, _to, msg.value);
    }

    function confirmTransaction(uint _transactionId) public {
        require(_transactionId<transactions.length,"Transaction Id not found.");
        require(!isConfirmed[_transactionId][msg.sender], "Transaction has already been confirmed.");
    
        transactions[_transactionId].isExecuted = true;
        isConfirmed[_transactionId][msg.sender] =true;
    }


    }
}
