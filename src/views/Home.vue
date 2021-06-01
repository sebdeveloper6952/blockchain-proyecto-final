<template>
  <div class="container">
    <!-- Inicia sidebar con detalles de res -->
    <b-sidebar
      type="is-light"
      fullheight="fullheight"
      overlay="overlay"
      right="right"
      v-model="open"
    >
      <div class="p-1">
        <div class="column">
          <b-field id="nTitle" label="Propiedades de red" />
          <div class="level-left">
            <b-field :label="`Network Id: ${networkId}`" />
          </div>
          <div class="level-left">
            <b-field :label="`Peer Count: ${peerCount}`" />
          </div>
          <div class="level-left">
            <b-field :label="`Block number: ${blockNumber}`" />
          </div>
          <div class="level-left">
            <b-field
              :label="`Block Transaction count: ${blockTransactionCount}`"
            />
          </div>
          <div class="level-left">
            <b-field :label="`Accounts cont: ${accountsAmount}`" />
          </div>
          <div class="level-left">
            <b-field :label="`Protocol version: ${protocolVersion}`" />
          </div>
          <div class="level-left">
            <b-field :label="`Gas price: ${gasPrice}`" />
          </div>
        </div>
      </div>
    </b-sidebar>
    <!-- Finaliza sidebar con detalles de res -->
    <!-- Inicia Menu principal -->
    <b-navbar centered>
      <template #brand>
        <b-navbar-item>
          <b-button
            style="width:140px"
            @click="connectToMeta"
            :disabled="connected"
            >Conectar</b-button
          >
        </b-navbar-item>
      </template>
      <template #start>
        <b-field
          id="nTitle"
          :label="`Interactuando con el contrato ${contractName}`"
        />
      </template>
      <template #end>
        <b-navbar-item>
          <b-button style="width:140px" @click="open = true">Detalles</b-button>
        </b-navbar-item>
      </template>
    </b-navbar>
    <br />
    <br />
    <div class="columns">
      <div class="column" style="text-align:center">
        <b-field label="Top 10 Cuentas">
          <b-table
            :data="topTenAccounts"
            :columns="columnsTopCuentas"
            :bordered="true"
            :centered="true"
          ></b-table>
        </b-field>
      </div>
      <div class="column" style="border-color:black">
        <div class="columns">
          <div class="column">
            <b-button
              style="width:660px"
              label="Seleccionar una billetera de origen"
              type="is-primary"
            />
          </div>
        </div>
        <b-input placeholder="Billetera de origen" v-model="accounts[0]">
        </b-input>
        <br />
        <div class="columns">
          <div class="column">
            <b-button
              style="width:660px"
              label="Seleccionar una billetera de destino"
              type="is-primary"
            />
          </div>
        </div>
        <b-input placeholder="Billetera de destino" v-model="accountReceiver">
        </b-input>
        <b-field label="Cantidad">
          <b-numberinput
            v-model="transactionValue"
            min="0"
            :max="balance"
            controls-alignment="right"
          ></b-numberinput>
        </b-field>
        <b-field :label="`Balance: ${balance}`" />
        <b-button
          label="Enviar"
          type="is-primary"
          :disabled="!accountReceiver || !transactionValue"
          @click="testTransfer(accountReceiver, transactionValue * 10 ** 8)"
        />
      </div>
    </div>
    <b-field label="Ultimas 20 Transacciones">
      <b-table
        :data="transferHistory"
        :columns="columnsHistorialCuentas"
        :bordered="true"
        :centered="true"
      ></b-table>
    </b-field>
    <br />
  </div>
</template>
<style lang="scss">
#nTitle {
  text-align: center;
  label {
    font-weight: bold;
    font-size: 30px;
    color: #42b983;
  }
}
</style>

<script>
export default {
  name: "Home",
  components: {},
  data() {
    return {
      contractName: "",
      open: false,
      isLoading: false,
      accounts: [],
      accountSender: "",
      accountReceiver: "",
      balance: 0,
      transactionValue: 0,
      networkId: 0,
      peerCount: 0,
      blockNumber: 0,
      blockTransactionCount: 0,
      accountsAmountReq: 0,
      accountsAmount: 0,
      protocolVersion: 0,
      gasPrice: 0,
      connected: false,
      topTenAccounts: [],
      transferHistory: [],
      columnsTopCuentas: [
        {
          field: "address",
          label: "Direccion",
        },
        {
          field: "balance",
          label: "Balance",
        },
      ],
      columnsHistorialCuentas: [
        {
          field: "from",
          label: "Origen",
        },
        {
          field: "to",
          label: "Destino",
        },
        {
          field: "amount",
          label: "Monto",
        },
      ],
    };
  },
  async mounted() {
    // initialize contract instantiation
    this.$store.dispatch("initializeContract", {
      onTransfer: this.onTransferEvent,
      onInit: this.onContractInit,
    });
    this.fetchAccounts();
    this.fetchGasPrice();
    this.fetchProtocolVersion();
    this.fetchBlockTransactionCount();
    this.fetchBlockNumber();
    this.fetchNetworkId();
    this.fetchPeerCount();
  },
  methods: {
    onContractInit() {
      this.testTopTen();
      this.testLastTransfers();
      this.testName();
    },
    toast(message) {
      this.$buefy.toast.open({
        duration: 5000,
        message: ` Transacción exitosa. Hash ${message}`,
        position: "is-bottom",
        type: "is-success",
      });
    },
    async fetchGasPrice() {
      this.gasPrice = await this.$store.state.web3.eth.getGasPrice();
    },
    async fetchProtocolVersion() {
      this.protocolVersion = await this.$store.state.web3.eth.getProtocolVersion();
    },
    async fetchBlockTransactionCount() {
      this.blockTransactionCount = await this.$store.state.web3.eth.getBlockTransactionCount();
    },
    async fetchBlockNumber() {
      this.blockNumber = await this.$store.state.web3.eth.getBlockNumber();
    },
    async fetchNetworkId() {
      this.networkId = await this.$store.state.web3.eth.net.getId();
    },
    async fetchPeerCount() {
      this.peerCount = await this.$store.state.web3.eth.net.getPeerCount();
    },
    async fetchAccounts() {
      this.accounts = await this.$store.state.web3.eth.getAccounts();
      this.accountsAmount = this.accounts.length;
      this.testBalance(this.accounts[0]);
    },
    async requestAccounts() {
      await this.$store.state.web3.eth.requestAccounts();
    },
    async fetchBalance(address) {
      this.balance = await this.$store.state.web3.eth.getBalance(address);
    },
    async getAccountsBalance(address) {
      this.fetchBalance(address);
    },
    async fetchTransaction() {
      const response = await this.$store.state.web3.eth.sendTransaction({
        from: this.accounts[0],
        to: this.accountReceiver,
        value: this.transactionValue,
      });

      this.toast(response.transactionHash);
      this.fetchBalance(this.accountSender);
      this.fetchBlockNumber();
      this.fetchBlockTransactionCount();
    },
    /// Connect to MetaMask by requesting the user accounts. Then,
    /// get the user accounts and save them in data.
    connectToMeta() {
      this.$store.state.web3.eth.requestAccounts().then((res) => {
        if (res && res.length) {
          this.$store.state.web3.eth.getAccounts().then((accounts) => {
            this.accounts = accounts;
            this.connected = true;
            this.$buefy.toast.open({
              type: "is-success",
              message: "Conectado exitosamente!",
            });
          });
        }
      });
    },
    testName() {
      this.$store.state.contract.methods
        .name()
        .call()
        .then((result) => {
          this.contractName = result;
        });
    },
    testSymbol() {
      this.$store.state.contract.methods
        .symbol()
        .call()
        .then((result) => {
          this.$buefy.toast.open(result);
        });
    },
    testDecimals() {
      this.$store.state.contract.methods
        .decimals()
        .call()
        .then((result) => {
          this.$buefy.toast.open(result);
        });
    },
    testTotalSupply() {
      this.$store.state.contract.methods
        .totalSupply()
        .call()
        .then((result) => {
          this.$buefy.toast.open(result);
        });
    },
    testBalance(address) {
      this.$store.state.contract.methods
        .balanceOf(address)
        .call()
        .then((result) => {
          this.balance = (result / 10 ** 8).toFixed(2);
        });
    },
    testTransfer(to, amount) {
      this.$buefy.notification.open({
        position: "is-top-right",
        type: "is-success",
        duration: 5000,
        message: "Transacción enviada, por favor espere.",
      });
      this.$store.state.contract.methods
        .transfer(to, amount)
        .send({ from: this.accounts[0] })
        .then((result) => {
          console.log(result);
        });
    },
    testLastTransfers() {
      this.$store.state.contract.methods
        .lastTransfers()
        .call()
        .then((result) => {
          if (result[0] && result[1] && result[2]) {
            const from = result[0];
            const to = result[1];
            const amount = result[2];
            for (let i = 0; i < from.length; i++) {
              this.transferHistory.push({
                from: from[i],
                to: to[i],
                amount: (amount[i] / 10 ** 8).toFixed(2),
              });
            }
          }
        });
    },
    testTopTen() {
      this.$store.state.contract.methods
        .topTen()
        .call()
        .then((result) => {
          if (result[0]) {
            const addresses = result[0];
            const balances = result[1];
            for (let i = 0; i < result[0].length; i++) {
              this.topTenAccounts.push({
                address: addresses[i],
                balance: (balances[i] / 10 ** 8).toFixed(2),
              });
            }
          }
        });
    },
    onTransferEvent(data) {
      this.$buefy.toast.open({
        duration: 5000,
        type: "is-success",
        message:
          "DESDE: " +
          data[0] +
          " SE ENVIO " +
          data[2] +
          " A LA CUENTA: " +
          data[1],
      });
    },
  },
};
</script>
