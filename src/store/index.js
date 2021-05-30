import Vue from "vue";
import Vuex from "vuex";
import Web3 from "web3";
import Token from "../../abi/Token.json";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    web3: new Web3(Web3.givenProvider),
    contract: {},
    contractAddress: "0x36775f4bfF8f67c380085DffD67e6Ae07c067f33",
  },
  actions: {
    initializeContract({ state }) {
      state.contract = new state.web3.eth.Contract(
        Token.abi,
        state.contractAddress
      );
    },
  },
});
