module.exports = async ({
    getNamedAccounts,
    deployments,
  }) => {
    let networkName;
    const Resolver_CONTRACT = "Resolver";
    const {deploy} = deployments;
    const {deployer,admin} = await getNamedAccounts();
    logic = await deployments.get(Resolver_CONTRACT)

    console.log(`>>> deployer address ${deployer}`);
    console.log(`>>> admin address ${admin}`);
    await deploy('EternalStorageProxy', {
      from: deployer,
      args: [logic.address,admin,"0x"],
      log: true,
      waitConfirmations:1,
    });
  };

  module.exports.tags = ["EXTERNAL_STORAGE"];