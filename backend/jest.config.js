module.exports = {
  testEnvironment: 'node', // Informa ao Jest que estamos testando um ambiente Node.js
  coveragePathIgnorePatterns: [ // Pastas que não precisam de cobertura de teste
    "/node_modules/"
  ],
  setupFilesAfterEnv: ['./jest.setup.js']
}
