import Vue from "vue";
import Vuex from "vuex";
import Web3 from "web3";
import Token from "../../abi/Token.json";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    web3: new Web3(Web3.givenProvider),
    contract: {},
    contractAddress: "0x2d757966e644F5C663145AC4f0717a9398Da4f72",
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
