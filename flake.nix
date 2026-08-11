{
  description = "Dotfiles & Development Templates Catalog";

  outputs = { self }: {
    templates = {
      java-spring = {
        path = ./templates/java-spring;
        description = "Java 21 + Spring Boot + JDTLS + DAP IDE environment";
      };
      multi-lang = {
        path = ./templates/multi-lang;
        description = "Multi-language development laboratory environment";
      };
    };
  };
}
