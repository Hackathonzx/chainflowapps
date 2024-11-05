const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AstroPet Contract", function () {
  let AstroPet, astroPet, owner, addr1, addr2;

  beforeEach(async function () {
    AstroPet = await ethers.getContractFactory("AstroPet");
    [owner, addr1, addr2] = await ethers.getSigners();
    astroPet = await AstroPet.deploy();
    await astroPet.waitForDeployment();
  });

  describe("Minting AstroPets", function () {
    it("Should allow the owner to mint a new AstroPet", async function () {
      await astroPet.connect(owner).mintAstroPet(addr1.address, "https://example.com/token/1", "Earth");
      expect(await astroPet.balanceOf(addr1.address)).to.equal(1);
    });

    it("Should not allow non-owner to mint a new AstroPet", async function () {
      await expect(
        astroPet.connect(addr1).mintAstroPet(addr2.address, "https://example.com/token/2", "Mars")
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });

    it("Should enforce mint limit per address", async function () {
      for (let i = 0; i < 5; i++) {
        await astroPet.connect(owner).mintAstroPet(addr1.address, `https://example.com/token/${i}`, "Earth");
      }
      await expect(
        astroPet.connect(owner).mintAstroPet(addr1.address, "https://example.com/token/6", "Mars")
      ).to.be.revertedWith("Mint limit reached for this address");
    });
  });

  describe("Event Management", function () {
    it("Should allow the owner to create a new event", async function () {
      await astroPet.connect(owner).createEvent("Pet Contest", "A contest for pets", Math.floor(Date.now() / 1000), Math.floor(Date.now() / 1000) + 3600);
      const event = await astroPet.events(0);
      expect(event.eventName).to.equal("Pet Contest");
    });

    it("Should allow users to participate in an event", async function () {
      await astroPet.connect(owner).createEvent("Pet Contest", "A contest for pets", Math.floor(Date.now() / 1000), Math.floor(Date.now() / 1000) + 3600);
      await astroPet.connect(addr1).participateInEvent(0);
      const event = await astroPet.getEvent(0);
      expect(event.participants.length).to.equal(1);
      expect(event.participants[0]).to.equal(addr1.address);
    });
  });


  describe("Reward Management", function () {
    it("Should allow the owner to distribute rewards", async function () {
      await astroPet.connect(owner).distributeRewards(addr1.address, ethers.parseEther("1"));
      expect(await astroPet.rewards(addr1.address)).to.equal(ethers.parseEther("1"));
    });

    it("Should allow users to claim their rewards", async function () {
      await astroPet.connect(owner).distributeRewards(addr1.address, ethers.parseEther("1"));
      await astroPet.connect(owner).depositETH({ value: ethers.parseEther("1") });
      await astroPet.connect(addr1).claimRewards();
      expect(await astroPet.rewards(addr1.address)).to.equal(0);
    });
  });

  describe("ETH Deposits", function () {
    it("Should allow the owner to deposit ETH into the contract", async function () {
      await astroPet.connect(owner).depositETH({ value: ethers.parseEther("1") });
      expect(await astroPet.getContractBalance()).to.equal(ethers.parseEther("1"));
    });

    it("Should fail if non-owner tries to deposit ETH", async function () {
      await expect(astroPet.connect(addr1).depositETH({ value: ethers.parseEther("1") })).to.be.revertedWith("Ownable: caller is not the owner");
    });
  });
});
