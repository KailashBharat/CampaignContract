// import "dotenv/config"
import web3 from "./web3";
import CampaignFactory from "./build/CampaignFactory.json";

const instance = new web3.eth.Contract(
  CampaignFactory.abi,
  "0x48f7933354E55bBCEccb3f05022D720f8b0c0c22"
);

export default instance;
