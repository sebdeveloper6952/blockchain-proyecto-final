import Vue from "vue";
import Vuex from "vuex";
import Web3 from "web3";
import Token from "../../abi/Token.json";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    web3: new Web3(Web3.givenProvider),
    contract: {},
    contractAddress: "0x7b70da475E16e2f7781f5a1CADaA741Aef684184",
  },
  actions: {
    initializeContract({ state }, data) {
      state.contract = new state.web3.eth.Contract(
        Token.abi,
        state.contractAddress
      );
      data.onInit();
      state.contract.events.Transfer().on("data", function(event) {
        data.onTransfer(event.returnValues);
      });
    },
  },
});
