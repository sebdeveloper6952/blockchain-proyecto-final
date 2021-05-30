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
        <b-field id="nTitle" label="Bienvenido" />
      </template>
      <template #end>
        <b-navbar-item>
          <b-button style="width:140px" @click="open = true">Detalles</b-button>
        </b-navbar-item>
      </template>
    </b-navbar>
    <!-- Finaliza Menu principal -->
    <br />
    <br />
    <!-- Inicia cuerpo de contrato -->
    <div class="columns">
      <!-- Inicia columna izquierda vacia -->
      <div class="column" style="text-align:center">
        <b-field label="Top 10 Cuentas">
          <b-table
            :data="topCuentas"
            :columns="columnsTopCuentas"
            :bordered="true"
            :centered="true"
          ></b-table>
        </b-field>
      </div>
      <!-- Finaliza columna izquierda vacia -->
      <!-- Inicia columna central-->
      <div class="column" style="border-color:black">
        <div class="columns">
          <div class="column">
            <!-- <b-dropdown
              v-model="accountSender"
              aria-role="list"
              @change="getAccountsBalance"
            >
            <template #trigger="{ active }"> -->
            <b-button
              style="width:660px"
              label="Seleccionar una billetera de origen"
              type="is-primary"
            />
            <!-- </template>
            <b-dropdown-item
              v-for="a in accounts"
              :key="a"
              :value="a"
              aria-role="listitem"
            >
            {{ a }}
            </b-dropdown-item>
            </b-dropdown> -->
          </div>
        </div>
        <b-input placeholder="Billetera de origen" v-model="accounts[0]">
        </b-input>
        <br />
        <div class="columns">
          <div class="column">
            <!-- <b-dropdown  v-model="accountReceiver" aria-role="list">
              <template #trigger="{ active }"> -->
            <b-button
              style="width:660px"
              label="Seleccionar una billetera de destino"
              type="is-primary"
            />
            <!-- </template>
              <b-dropdown-item 
                v-for="a in accounts"
                :key="a"
                :value="a"
                aria-role="listitem"
                >{{ a }}</b-dropdown-item
              >
            </b-dropdown> -->
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
        <b-button label="Enviar" type="is-primary" @click="fetchTransaction" />
      </div>
      <!-- <div class="column">
                        <b-button
                  style="width:300px"
                  label="Seleccionar una billetera de destino"
                  type="is-primary"
                />
        <b-table :data="historialCuentas" :columns="columnsHistorialCuentas" :bordered="true" :centered="true"></b-table>
      </div>
    </div> -->
    </div>
    <b-field label="Ultimas 20 Transacciones">
      <b-table
        :data="historialCuentas"
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
      topCuentas: [
        { name: "0xabF85c6E4900bf16474e9187733793708709450b", balance: "1" },
        { name: "Paul Beleches", balance: "2" },
        { name: "Paul Beleches", balance: "3" },
        { name: "Paul Beleches", balance: "4" },
        { name: "Paul Beleches", balance: "5" },
        { name: "Paul Beleches", balance: "6" },
        { name: "Paul Beleches", balance: "7" },
        { name: "Paul Beleches", balance: "8" },
        { name: "Paul Beleches", balance: "9" },
        { name: "Paul Beleches", balance: "10" },
      ],
      columnsTopCuentas: [
        {
          field: "name",
          label: "Direccion",
        },
        {
          field: "balance",
          label: "Balance",
        },
      ],
      historialCuentas: [
        {
          name1: "0xabF85c6E4900bf16474e9187733793708709450b",
          name2: "0xabF85c6E4900bf16474e9187733793708709450b",
          monto: "1",
        },
        { name1: "Paul Beleches", name2: "Sebas Arriola", monto: "2" },
        { name1: "Paul Beleches", name2: "Sebas Arriola", monto: "3" },
        { name1: "Paul Beleches", name2: "Sebas Arriola", monto: "4" },
        { name1: "Paul Beleches", name2: "Sebas Arriola", monto: "5" },
        { name1: "Paul Beleches", name2: "Sebas Arriola", monto: "6" },
        { name1: "Paul Beleches", name2: "Sebas Arriola", monto: "7" },
        { name1: "Paul Beleches", name2: "Sebas Arriola", monto: "8" },
        { name1: "Paul Beleches", name2: "Sebas Arriola", monto: "9" },
        { name1: "Paul Beleches", name2: "Sebas Arriola", monto: "10" },
      ],
      columnsHistorialCuentas: [
        {
          field: "name1",
          label: "Direccion 1",
        },
        {
          field: "name2",
          label: "Direccion 2",
        },
        {
          field: "monto",
          label: "Monto",
        },
      ],
    };
  },
  async mounted() {
    // initialize contract instantiation
    this.$store.dispatch("initializeContract", this.onTransferEvent);
    this.fetchAccounts();
    this.fetchGasPrice();
    this.fetchProtocolVersion();
    this.fetchBlockTransactionCount();
    this.fetchBlockNumber();
    this.fetchNetworkId();
    this.fetchPeerCount();
  },
  methods: {
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
      this.fetchBalance(this.accounts[0]);
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
          this.$buefy.toast.open(result);
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
    testBalance() {
      this.$store.state.contract.methods
        .balanceOf(this.accounts[0])
        .call()
        .then((result) => {
          this.$buefy.toast.open(`Balance: ${result}`);
        });
    },
    testTransfer(to, amount) {
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
          console.log(result);
        });
    },
    testTopTen() {
      this.$store.state.contract.methods
        .topTen()
        .call()
        .then((result) => {
          console.log(result);
        });
    },
    onTransferEvent(data) {
      console.log(`onData: ${data[0]}`);
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
