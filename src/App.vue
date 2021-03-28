<template>
  <div id="app">
    <div id="sidebar">
      <!-- <div id="sidebar-header" class="page-header"></div> -->
      <div id="sidebar-account">
        <div class="account-address sidebar-link-text">{{ ethereumAddress }}</div>
      </div>
      <ul>
        <router-link to="/" v-slot="{ href, navigate, isExactActive }" exact>
          <li :class="{ 'active': isExactActive == true }">
            <a :href="href" @click="navigate">
              <font-awesome-icon icon="home" />
              <span class="sidebar-link-text">Home</span>
            </a>
          </li>
        </router-link>
        <router-link to="/account" v-slot="{ href, navigate, isExactActive }" exact>
          <li :class="{ 'active': isExactActive == true }">
            <a :href="href" @click="navigate">
              <font-awesome-icon icon="address-card" />
              <span class="sidebar-link-text">Account</span>
            </a>
          </li>
        </router-link>
      </ul>
    </div>
    <div id="content">
      <img id="header-logo" src="@/assets/edf-logo.png"/>
      <!-- <div id="content-header" class="page-header">
        <h1>EDF Crowdsale</h1>
      </div> -->

      <div id="content-body">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script>
const MetaMask = require('@/lib/MetaMask');

export default {
  name: 'App',
  components: {},
  data() {
    return {
      ethereumAddress: null
    }
  },
  created() {
    MetaMask.getAccounts()
      .then((accounts) => {
        this.ethereumAddress = accounts[0].substring(0, 15)
      })
      .catch((error) => {
        console.log(error);
      })
  }
}
</script>

<style>
#app {
  font-family: 'Roboto', Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

body,
html {
  overflow-x: hidden;
  margin: 0;
  padding: 0;
}

.page-header {
  height: 50px;
  width: 100%;
}

#sidebar-header {
  background-color: #525198;
  text-align: center;
  font-size: 32px;
  color: #dedfe0;
}

#sidebar-header img {
  width: 80%;
}

#content-header {
  background-color: #5d5ba7;
  text-align: center;
}

#content-header h1 {
  font-size: 30px;
  color: #ffffff;
  margin: 0;
  padding: 0;
  font-weight: 100;
  padding-top: 5px;
}

#header-logo {
  width: 200px;
  padding: 25px;
  text-align: left;
}

#sidebar {
  width: 180px;
  position: fixed;
  height: 100%;
  height: 100vh;
  background-color: #212d32;
}

#sidebar ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

#sidebar ul li a {
  padding: 15px;
  padding-top: 10px;
  padding-bottom: 10px;
  text-align: left;
  background-color: #212d32;
  font-weight: 100;
  color: #b0c0c7;
  text-decoration: none;
  display: block;
}

#sidebar ul li a:hover,
#sidebar ul li.active a {
  background-color: #1d282c;
  color: #dedfe0;
}

.sidebar-link-text {
  vertical-align: middle;
  padding-left: 5px;
}

#sidebar-account {
  padding-top: 15px;
  padding-bottom: 15px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

.account-icon {
  display: inline-block;
}

.account-icon svg {
  width: 40px;
  height: 40px;
}

.account-address {
  color: #dedfe0;
  font-size: 0.9em;
  display: inline-block;
}

#content {
  position: relative;
  left: 180px;
  width: calc(100% - 180px);
}

#content-body {
  max-width: 600px;
  margin: auto;
  padding: 15px;
  text-align: left;
}

section {
  margin-bottom: 20px;
}

@media screen and (max-width: 600px) {
  #sidebar {
    width: 50px;
  }

  #content {
    left: 50px;
    width: calc(100% - 50px);
  }

  #sidebar-header {
    font-size: 24px;
  }

  #sidebar-account {
    padding: 5px;
    text-align: center;
    padding-top: 15px;
  }

  .account-icon svg {
    width: 30px;
    height: 30px;
  }

  .sidebar-link-text {
    display: none;
  }
}
</style>
