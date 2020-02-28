import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { PCatalogOffer } from "./PCatalogOffer";
import { File } from "./File";
import { PProduct } from "./PProduct";

@Index("POffer_productId", ["productId"], {})
@Index("POffer_imageId", ["imageId"], {})
@Entity("POffer", { schema: "db" })
export class POffer {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", nullable: true, length: 128 })
  name: string | null;

  @Column("varchar", { name: "ref", length: 32 })
  ref: string;

  @Column("double", { name: "quantity", nullable: true, precision: 22 })
  quantity: number | null;

  @Column("double", { name: "vat", precision: 22 })
  vat: number;

  @Column("tinyint", { name: "active", width: 1 })
  active: boolean;

  @Column("int", { name: "productId" })
  productId: number;

  @Column("double", { name: "stock", nullable: true, precision: 22 })
  stock: number | null;

  @Column("int", { name: "imageId", nullable: true })
  imageId: number | null;

  @Column("double", { name: "price", precision: 22 })
  price: number;

  @OneToMany(
    () => PCatalogOffer,
    pCatalogOffer => pCatalogOffer.offer
  )
  pCatalogOffers: PCatalogOffer[];

  @ManyToOne(
    () => File,
    file => file.pOffers,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "imageId", referencedColumnName: "id" }])
  image: File;

  @ManyToOne(
    () => PProduct,
    pProduct => pProduct.pOffers,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "productId", referencedColumnName: "id" }])
  product: PProduct;
}
