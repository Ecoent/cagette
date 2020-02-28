import { Column, Entity } from "typeorm";

@Entity("Graph", { schema: "db" })
export class Graph {
  @Column("varchar", { primary: true, name: "key", length: 128 })
  key: string;

  @Column("date", { primary: true, name: "date" })
  date: string;

  @Column("double", { name: "value", precision: 22 })
  value: number;
}
