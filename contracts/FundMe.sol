// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";



contract FundMe{

  using PriceConverter for uint256;



     address public immutable owner;
     constructor(){

      owner=msg.sender;



     }

     error NotOwner();


     modifier  onlyOwner(){

      if(msg.sender!=owner){

        revert NotOwner();
      }
      _;
     }



    uint public constant MINIMUM_USD=5e18;

    address[] public funders;
    mapping(address=>uint256) public addressToAmountFunded;




    

    function fund() public payable {

      

        require(msg.value.getConversionRate()>MINIMUM_USD, "insufficient amount");

        funders.push(msg.sender);

        addressToAmountFunded[msg.sender]=msg.value;




    }

    


   function withdraw() public onlyOwner{

    for(uint i=0; i<funders.length; i++){

      address funder=funders[i];
      addressToAmountFunded[funder]=0;

    }

    funders=new address[](0);

    (bool success,)=payable(msg.sender).call{value:address(this).balance}("");
    require(success, "transfer failed");





    }

    receive() external payable{

      fund();
    }


    fallback() external payable{


      fund();
    }

   




}

//0x653BB69EE6d44c7B103509eC100A40EdfCdF80c8