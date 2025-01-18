# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react/README.md) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## Configuring the RPC Endpoint

To interact with Starknet using Starkli, you can configure a custom RPC endpoint. This can be done in two ways:

1. **Using the --rpc flag**:
   You can specify the RPC endpoint directly when running Starkli by using the `--rpc` flag. For example:
   ```
   starkli --network=sepolia --rpc=https://your-custom-rpc-endpoint
   ```

2. **Setting the STARKNET_RPC environment variable**:
   Alternatively, you can set the `STARKNET_RPC` environment variable in your shell:
   ```bash
   export STARKNET_RPC=https://your-custom-rpc-endpoint
   ```

Make sure to replace `https://your-custom-rpc-endpoint` with the actual RPC endpoint you wish to use.

## Declaring a Smart Contract

A contract can be declared on Starknet using Starkli by running the following command:

```bash
starkli declare target/dev/<CONTRACT_NAME>.contract_class.json --network=sepolia
```

When using `starkli declare`, Starkli will do its best to identify the compiler version of the declared class. In case it fails, the `--compiler-version` flag can be used to specify the version of the compiler as follows:

To find the compiler versions supported by Starkli, run:

```bash
starkli declare --help
```

and look for the possible values of the `--compiler-version` flag.

To find the current Scarb version in use, run:

```bash
scarb --version
```

If a different compiler version is required, switch to a different Scarb version using `asdf`:

1. Install the desired Scarb version:
   ```bash
   asdf install scarb <VERSION>
   ```

2. Select the desired Scarb version as the local version for the project:
   ```bash
   asdf local scarb <VERSION>
   ```

### Example of Declaring a Contract

Here is an example of declaring a contract with both a custom RPC endpoint (provided by Infura) and a specific compiler version:

```bash
starkli declare target/dev/<CONTRACT_NAME>.contract_class.json \
    --rpc=https://starknet-sepolia.infura.io/v3/<API_KEY> \
    --compiler-version=2.6.0
```

### Expected Result

The output of a successful contract declaration using Starkli should resemble the following:

```
Class hash declared: <CLASS_HASH>
```

On the other hand, if the contract you are declaring has previously been declared, the output should resemble the following:

```
Not declaring class as it's already declared. Class hash: <CLASS_HASH>
```

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type aware lint rules:

- Configure the top-level `parserOptions` property like this:

```js
export default tseslint.config({
  languageOptions: {
    // other options...
    parserOptions: {
      project: ['./tsconfig.node.json', './tsconfig.app.json'],
      tsconfigRootDir: import.meta.dirname,
    },
  },
})
```

- Replace `tseslint.configs.recommended` to `tseslint.configs.recommendedTypeChecked` or `tseslint.configs.strictTypeChecked`
- Optionally add `...tseslint.configs.stylisticTypeChecked`
- Install [eslint-plugin-react](https://github.com/jsx-eslint/eslint-plugin-react) and update the config:

```js
// eslint.config.js
import react from 'eslint-plugin-react'

export default tseslint.config({
  // Set the react version
  settings: { react: { version: '18.3' } },
  plugins: {
    // Add the react plugin
    react,
  },
  rules: {
    // other rules...
    // Enable its recommended rules
    ...react.configs.recommended.rules,
    ...react.configs['jsx-runtime'].rules,
  },
})
