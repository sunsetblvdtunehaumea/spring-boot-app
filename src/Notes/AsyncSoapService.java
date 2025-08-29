@Service
public class AsyncSoapService {

    @Autowired
    private CreditCardAdaptor creditCardAdaptor;

    @Autowired
    private AccountAdaptor accountAdaptor;

    @Async("soapTaskExecutor")
    public CompletableFuture<FinancialProfileVO> getFinancialProfileAsync(
            RequestContext requestContext, Long deviceId) {
        try {
            FinancialProfileVO profile = creditCardAdaptor.getFinancialProfile(requestContext, deviceId);
            return CompletableFuture.completedFuture(profile);
        } catch (Exception e) {
            CompletableFuture<FinancialProfileVO> future = new CompletableFuture<>();
            future.completeExceptionally(e);
            return future;
        }
    }

    @Async("soapTaskExecutor")
    public CompletableFuture<Balance> getBalanceAsync(
            RequestContext requestContext, Long accountId) {
        try {
            Balance balance = accountAdaptor.getBalance(requestContext, accountId);
            return CompletableFuture.completedFuture(balance);
        } catch (Exception e) {
            CompletableFuture<Balance> future = new CompletableFuture<>();
            future.completeExceptionally(e);
            return future;
        }
    }
}