public StatementSummary getCurrentStatementSummary(
        RequestContext requestContext, Long accountId, Long deviceId) {

    try {
        // Create async calls using CompletableFuture.supplyAsync with custom executor
        CompletableFuture<FinancialProfileVO> financialProfileFuture = CompletableFuture.supplyAsync(() -> {
            return creditCardAdaptor.getFinancialProfile(requestContext, deviceId);
        }, soapTaskExecutor); // Inject the executor bean

        CompletableFuture<Balance> balanceFuture = CompletableFuture.supplyAsync(() -> {
            return accountAdaptor.getBalance(requestContext, accountId);
        }, soapTaskExecutor);

        // Wait for both and get results
        FinancialProfileVO financialProfile = financialProfileFuture.get(30, TimeUnit.SECONDS);
        Balance balance = balanceFuture.get(30, TimeUnit.SECONDS);

        return statementMapper.getCurrentStatementSummary(balance, financialProfile);

    } catch (ServiceException ex) {
        throw ex;
    } catch (Exception e) {
        // Your existing exception handling logic
        // ...
    }
}