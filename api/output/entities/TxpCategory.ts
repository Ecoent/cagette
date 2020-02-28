import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { TxpProduct } from "./TxpProduct";
import { TxpSubCategory } from "./TxpSubCategory";

@Entity("TxpCategory", { schema: "db" })
export class TxpCategory {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("varchar", { name: "image", nullable: true, length: 64 })
  image: string | null;

  @Column("tinyint", { name: "displayOrder" })
  displayOrder: number;

  @OneToMany(
    () => TxpProduct,
    txpProduct => txpProduct.category
  )
  txpProducts: TxpProduct[];

  @OneToMany(
    () => TxpSubCategory,
    txpSubCategory => txpSubCategory.category
  )
  txpSubCategories: TxpSubCategory[];
}
