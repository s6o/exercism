import java.util.HashMap;
import java.util.Map;

public class DialingCodes {
    private Map<Integer, String> byCodes = new HashMap<>();
    private Map<String, Integer> byCountries = new HashMap<>();

    public Map<Integer, String> getCodes() {
        return byCodes;
    }

    public void setDialingCode(Integer code, String country) {
        byCodes.put(code, country);
        byCountries.put(country, code);
    }

    public String getCountry(Integer code) {
        return byCodes.get(code);
    }

    public void addNewDialingCode(Integer code, String country) {
        if (!byCodes.containsKey(code) && !byCountries.containsKey(country)) {
            setDialingCode(code, country);
        }
    }

    public Integer findDialingCode(String country) {
        return byCountries.containsKey(country) ? byCountries.get(country) : null;
    }

    public void updateCountryDialingCode(Integer code, String country) {
        int oldCode = findDialingCode(country);
        byCodes.remove(oldCode);
        byCountries.remove(country);
        setDialingCode(code, country);
    }
}
