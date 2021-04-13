// flow transactions send --code Mint.cdc --signer admin-account

import Pixori from 0x05f5f6e2056f588b 

transaction {
// transaction(metadata: {String: String}) {

    let receiverRef: &{Pixori.NFTReceiver}
    let minterRef: &Pixori.NFTMinter

    prepare(acct: AuthAccount) {

        self.receiverRef = acct.getCapability<&{Pixori.NFTReceiver}>(/public/NFTReceiver)
            .borrow()
            ?? panic("Could not borrow receiver reference")
        
        self.minterRef = acct.borrow<&Pixori.NFTMinter>(from: /storage/NFTMinter)
            ?? panic("Could not borrow minter reference")
    }

    execute {

        let newNFT <- self.minterRef.mintNFT()

        // delete def. below
        let metadata: {String: String} = {
            "name": "example3",
            "time": "11:33 PM",
            "location": "home"
        }
        self.receiverRef.deposit(token: <-newNFT, metadata: metadata)
        // Error: GraphQL error: failed to decode argument 0: failed to decode value: invalid JSON Cadence structure

        log("NFT Minted and deposited to the Current user's Collection")
    }
}
