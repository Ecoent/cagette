import typescript from 'rollup-plugin-typescript2'
import commonjs from 'rollup-plugin-commonjs'
import external from 'rollup-plugin-peer-deps-external'
import resolve from 'rollup-plugin-node-resolve'
import del from 'rollup-plugin-delete'

import pkg from '../package.json'

export default {
  input: 'src2/index.tsx',
  output: [
    {
      file: pkg["main"],
      format: 'cjs',
      exports: 'named',
      sourcemap: true
    },
    {
      file: pkg["module"],
      format: 'es',
      exports: 'named',
      sourcemap: true
    }
  ],
  plugins: [
    del({ targets: `${pkg.libdir}/*`}),
    external(),
    resolve(),
    typescript({
      tsconfig: ".rollup/tsconfig.json",
      rollupCommonJSResolveHack: true,
      exclude: [
        '**/__tests__/**'
      ],
      clean: true
    }),
    commonjs({
      include: ['node_modules/**'],
      namedExports: {
        'node_modules/react/react.js': [
          'Children',
          'Component',
          'PropTypes',
          'createElement'
        ],
        'node_modules/react-dom/index.js': ['render']
      }
    })
  ]
}