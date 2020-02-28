import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { POffer } from "./POffer";
import { CagettePro } from "./CagettePro";
import { File } from "./File";
import { TxpProduct } from "./TxpProduct";

@Index("PProduct_companyId", ["companyId"], {})
@Index("PProduct_imageId", ["imageId"], {})
@Index("PProduct_txpProductId", ["txpProductId"], {})
@Entity("PProduct", { schema: "db" })
export class PProduct {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("varchar", { name: "ref", length: 32 })
  ref: string;

  @Column("mediumtext", { name: "desc", nullable: true })
  desc: string | null;

  @Column("double", { name: "stock", nullable: true, precision: 22 })
  stock: number | null;

  @Column("tinyint", { name: "hasFloatQt", width: 1 })
  hasFloatQt: boolean;

  @Column("tinyint", { name: "active", width: 1 })
  active: boolean;

  @Column("tinyint", { name: "unitType", nullable: true, unsigned: true })
  unitType: number | null;

  @Column("int", { name: "companyId" })
  companyId: number;

  @Column("int", { name: "imageId", nullable: true })
  imageId: number | null;

  @Column("int", { name: "txpProductId", nullable: true })
  txpProductId: number | null;

  @Column("tinyint", { name: "organic", width: 1 })
  organic: boolean;

  @Column("tinyint", { name: "variablePrice", width: 1 })
  variablePrice: boolean;

  @Column("tinyint", { name: "multiWeight", width: 1 })
  multiWeight: boolean;

  @Column("tinyint", { name: "retail", width: 1 })
  retail: boolean;

  @Column("tinyint", { name: "bulk", width: 1 })
  bulk: boolean;

  @Column("tinyint", { name: "wholesale", width: 1 })
  wholesale: boolean;

  @OneToMany(
    () => POffer,
    pOffer => pOffer.product
  )
  pOffers: POffer[];

  @ManyToOne(
    () => CagettePro,
    cagettePro => cagettePro.pProducts,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "companyId", referencedColumnName: "id" }])
  company: CagettePro;

  @ManyToOne(
    () => File,
    file => file.pProducts,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "imageId", referencedColumnName: "id" }])
  image: File;

  @ManyToOne(
    () => TxpProduct,
    txpProduct => txpProduct.pProducts,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "txpProductId", referencedColumnName: "id" }])
  txpProduct: TxpProduct;
}
