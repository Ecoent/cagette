import { Column, Entity } from "typeorm";

@Entity("Variable", { schema: "db" })
export class Variable {
  @Column("varchar", { primary: true, name: "name", length: 50 })
  name: string;

  @Column("varchar", { name: "value", length: 50 })
  value: string;
}
