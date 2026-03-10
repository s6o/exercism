class Badge {
    public String print(Integer id, String name, String department) {
        StringBuilder sb = new StringBuilder();
        if (id != null)
            sb.append("[").append(id).append("] - ");
        if (name != null)
            sb.append(name + " - ");
        if (department == null)
            sb.append("OWNER");
        else
            sb.append(department.toUpperCase());
        return sb.toString();
    }
}
