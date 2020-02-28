import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { EntityFile } from "./EntityFile";
import { Group } from "./Group";
import { POffer } from "./POffer";
import { PProduct } from "./PProduct";
import { Product } from "./Product";
import { Vendor } from "./Vendor";

@Entity("File", { schema: "db" })
export class File {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("tinytext", { name: "name" })
  name: string;

  @Column("mediumblob", { name: "data" })
  data: Buffer;

  @Column("datetime", { name: "cdate", nullable: true })
  cdate: Date | null;

  @OneToMany(
    () => EntityFile,
    entityFile => entityFile.file
  )
  entityFiles: EntityFile[];

  @OneToMany(
    () => Group,
    group => group.image
  )
  groups: Group[];

  @OneToMany(
    () => POffer,
    pOffer => pOffer.image
  )
  pOffers: POffer[];

  @OneToMany(
    () => PProduct,
    pProduct => pProduct.image
  )
  pProducts: PProduct[];

  @OneToMany(
    () => Product,
    product => product.image
  )
  products: Product[];

  @OneToMany(
    () => Vendor,
    vendor => vendor.image
  )
  vendors: Vendor[];
}
