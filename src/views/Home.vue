<template>
  <div class="container">
    <div class="columns">
      <div class="column" style="border-color:black">
        <div class="columns">
          <div class="column">
            <b-dropdown 
              v-model="accountSender" 
              aria-role="list"
              @change="getAccountsBalance">
              <template #trigger="{ active }">
                <b-button
                  label="Seleccionar una billetera"
                  type="is-primary"
                  :icon-right="active ? 'menu-up' : 'menu-down'" />
              </template>
              <b-dropdown-item v-for="a in accounts" :key="a" :value="a" aria-role="listitem">{{ a }}</b-dropdown-item>
            </b-dropdown>
          </div>
          <div class="column" style="margin-top:10px">
            <b-field label="Billetera origen">
            </b-field>
        </div>
      </div>
        <b-input 
          :value="accountSender">
        </b-input>
        <div class="columns">
          <div class="column">
        <b-dropdown 
          v-model="accountReceiver" 
          aria-role="list">
          <template #trigger="{ active }">
            <b-button
              label="Seleccionar una billetera"
              type="is-primary"
              :icon-right="active ? 'menu-up' : 'menu-down'" />
          </template>
          <b-dropdown-item v-for="a in accounts" :key="a" :value="a" aria-role="listitem">{{ a }}</b-dropdown-item>
        </b-dropdown>
          </div>
          <div class="column" style="margin-top:10px">
        <b-field label="Billetera destino">
        </b-field>
          </div>
        </div>
        <b-input 
          :value="accountReceiver">
        </b-input>
        <b-field label="Cantidad">
          <b-numberinput v-model="transactionValue" min=0 :max="balance" controls-alignment="right"></b-numberinput>
        </b-field> 
        <b-field :label="`Balance: ${balance}` "/>
        <b-button
              :disabled="!(accountSender.length > 0 && accountReceiver.length > 0 && transactionValue > 0)"
              label="Enviar"
              type="is-primary"
              @click="fetchTransaction" />
        </div>
      <div class="column">
        <div class="level-right"><b-field :label="`Network Id: ${networkId}` "/></div>
        <div class="level-right"><b-field :label="`Peer Count: ${peerCount}` "/></div>
        <div class="level-right"><b-field :label="`Block number: ${blockNumber}` "/></div>
        <div class="level-right"><b-field :label="`Block Transaction count: ${blockTransactionCount}` "/></div>
        <div class="level-right"><b-field :label="`Accounts cont: ${accountsAmount}` "/></div>
        <div class="level-right"><b-field :label="`Protocol version: ${protocolVersion}` "/></div>
        <div class="level-right"><b-field :label="`Gas price: ${gasPrice}` "/></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Home",
  components: {},
  data() {
    return {
      isLoading: false,
      accounts: [],
      accountSender: "",
      accountReceiver: "",
      balance: 0,
      transactionValue: 0,

      networkId: 0,
      peerCount: 0, 
      blockNumber:0,
      blockTransactionCount:0,
      accountsAmount: 0 ,
      protocolVersion: 0,
      gasPrice: 0,

    };
  },
  mounted() {
    this.fetchAccounts()
    this.fetchGasPrice()
    this.fetchProtocolVersion()
    this.fetchBlockTransactionCount()
    this.fetchBlockNumber()
    this.fetchNetworkId()
    this.fetchPeerCount()
  },
  methods: {
    toast(message) {
      this.$buefy.toast.open({
        duration: 5000,
        message:` Transacción exitosa. Hash ${message}`,
        position: 'is-bottom',
        type: 'is-success'
      
      })
    },
    async fetchGasPrice() {
      this.gasPrice = await this.$store.state.web3.eth.getGasPrice()
    },
    async fetchProtocolVersion() {
      this.protocolVersion = await this.$store.state.web3.eth.getProtocolVersion()
    },
    async fetchBlockTransactionCount() {
      this.blockTransactionCount = await this.$store.state.web3.eth.getBlockTransactionCount()
    }, 
    async fetchBlockNumber() {
      this.blockNumber = await this.$store.state.web3.eth.getBlockNumber()
    }, 
    async fetchNetworkId() {
      this.networkId = await this.$store.state.web3.eth.net.getId()
    }, 
    async fetchPeerCount() {
      this.peerCount = await this.$store.state.web3.eth.net.getPeerCount()
    }, 
    ///////////
    async fetchAccounts() {
      this.accounts = await this.$store.state.web3.eth.getAccounts()
      this.accountsAmount = this.accounts.length
    }, 
    async fetchBalance(address){
      this.balance = await this.$store.state.web3.eth.getBalance(address)
    },
    async getAccountsBalance (address){
      this.fetchBalance(address)
    },
    async fetchTransaction(){
      const response = await this.$store.state.web3.eth.sendTransaction(
        {
          from: this.accountSender,
          to: this.accountReceiver,
          value: this.transactionValue
        }
      )
      
      this.toast(response.transactionHash)
      this.fetchBalance(this.accountSender)
      this.fetchBlockNumber()
      this.fetchBlockTransactionCount()
      
    },
  },
};
</script>
