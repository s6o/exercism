import java.lang.Character;

class SqueakyClean {
    static String clean(String identifier) {
        char[] chs = identifier.toCharArray();
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < chs.length; i++) {
            switch (chs[i]) {
                case ' ':
                    sb.append('_');
                    break;
                case '-':
                    if (i + 1 < chs.length && Character.isLetter(chs[i + 1])) {
                        sb.append(Character.toUpperCase(chs[i + 1]));
                        i += 1;
                    }
                    break;
                case '4':
                    sb.append('a');
                    break;
                case '3':
                    sb.append('e');
                    break;
                case '0':
                    sb.append('o');
                    break;
                case '1':
                    sb.append('l');
                    break;
                case '7':
                    sb.append('t');
                    break;
                default:
                    if (Character.isLetter(chs[i]))
                        sb.append(chs[i]);
            }
        }
        return sb.toString();
    }
}
