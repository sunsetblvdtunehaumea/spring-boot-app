@Service
public class StatementService {

    @Autowired
    private AsyncSoapService asyncSoapService;

    public StatementSummary getCurrentStatementSummary(
            RequestContext requestContext, Long accountId, Long deviceId) {

        FinancialProfileVO financialProfile = null;
        Balance balance = null;

        try {
            // Start both async calls
            CompletableFuture<FinancialProfileVO> financialProfileFuture = asyncSoapService
                    .getFinancialProfileAsync(requestContext, deviceId);

            CompletableFuture<Balance> balanceFuture = asyncSoapService.getBalanceAsync(requestContext, accountId);

            // Wait for both to complete
            CompletableFuture<Void> allFutures = CompletableFuture.allOf(
                    financialProfileFuture, balanceFuture);

            // Block until both complete (with timeout)
            allFutures.get(30, TimeUnit.SECONDS);

            // Get results
            financialProfile = financialProfileFuture.get();
            balance = balanceFuture.get();

        } catch (ServiceException ex) {
            throw ex;
        } catch (TimeoutException ex) {
            log.error("Timeout occurred in getCurrentStatementSummary for contextId {} for accountId {}",
                    requestContext.getContextId(), accountId, ex);
            throw new ServiceException(ex.getMessage(), UNKNOWN_EXCEPTION_ERROR_CODE,
                    requestContext.getContextId(), true, HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (InterruptedException | ExecutionException e) {

            // Handle wrapped ServiceException
            if (e.getCause() instanceof ServiceException) {
                throw (ServiceException) e.getCause();
            }

            log.error(
                    "Interrupted or ExecutionException occurred in getCurrentStatementSummary for contextId {} for accountId {}",
                    requestContext.getContextId(), accountId, e);
            throw new ServiceException(e.getMessage(), UNKNOWN_EXCEPTION_ERROR_CODE,
                    requestContext.getContextId(), true, HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (Exception ex) {
            log.error("Exception occurred in getCurrentStatementSummary for contextId {} for accountId {}",
                    requestContext.getContextId(), accountId, ex);
            throw new ServiceException(ex.getMessage(), UNKNOWN_EXCEPTION_ERROR_CODE,
                    requestContext.getContextId(), true, HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return statementMapper.getCurrentStatementSummary(balance, financialProfile);
    }
}