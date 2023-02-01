require('dotenv').config();
module.exports = async function (taskArgs, hre) {
    const proxy = await ethers.getContract("EternalStorageProxy");
    const ResolverIssuerImpl = await ethers.getContract("Resolver");
    const contract = await ResolverIssuerImpl.attach(proxy.address)
    console.log(`[source] contract.address: ${contract.address}`);
  
    try {
        const {deployer} = await getNamedAccounts();
        console.log("owner:",deployer)
        const mumbai_qa = "0x3cB89e8540CD78c62Bcf4f91A90156BFEF309CE0";
        const mumbai_stg = "0x205144ad3BDFFBAD7cE2D7a5c575e1cb82480394";
        const platon_dev = "0x3cB89e8540CD78c62Bcf4f91A90156BFEF309CE0";
        const platon_qa = "0xf557422ee400DE76f74fC14229365Fb990895E62";
        const platon_stg = "0x2e1B35A177624aFD02ff054A078Cb1a97639DC6c";
        const baobab_qa = "0x3cB89e8540CD78c62Bcf4f91A90156BFEF309CE0";
        const baobab_stg = "0x3C5Bb6C09EfBbB8C81CFf31Bf38cEd3F9A246B10";
        let tx_init = await contract.initialize(baobab_stg);
        let init_receipt = await tx_init.wait();
        console.log("tx_init: ", init_receipt);
    } catch (e) {
        console.log(e);
      }
  };