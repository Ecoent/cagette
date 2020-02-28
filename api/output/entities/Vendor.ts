import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToMany,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { CagettePro } from "./CagettePro";
import { Catalog } from "./Catalog";
import { PCatalog } from "./PCatalog";
import { File } from "./File";
import { User } from "./User";
import { VendorStats } from "./VendorStats";

@Index("Vendor_imageId", ["imageId"], {})
@Index("Vendor_userId", ["userId"], {})
@Entity("Vendor", { schema: "db" })
export class Vendor {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("tinytext", { name: "email" })
  email: string;

  @Column("varchar", { name: "city", length: 25 })
  city: string;

  @Column("varchar", { name: "address1", nullable: true, length: 64 })
  address1: string | null;

  @Column("varchar", { name: "address2", nullable: true, length: 64 })
  address2: string | null;

  @Column("varchar", { name: "zipCode", length: 32 })
  zipCode: string;

  @Column("varchar", { name: "phone", nullable: true, length: 19 })
  phone: string | null;

  @Column("varchar", { name: "linkText", nullable: true, length: 256 })
  linkText: string | null;

  @Column("mediumtext", { name: "desc", nullable: true })
  desc: string | null;

  @Column("varchar", { name: "linkUrl", nullable: true, length: 256 })
  linkUrl: string | null;

  @Column("int", { name: "imageId", nullable: true })
  imageId: number | null;

  @Column("varchar", { name: "status", nullable: true, length: 32 })
  status: string | null;

  @Column("int", { name: "userId", nullable: true })
  userId: number | null;

  @Column("varchar", { name: "country", nullable: true, length: 64 })
  country: string | null;

  @Column("mediumtext", { name: "longDesc", nullable: true })
  longDesc: string | null;

  @Column("mediumtext", { name: "offCagette", nullable: true })
  offCagette: string | null;

  @Column("int", { name: "profession", nullable: true })
  profession: number | null;

  @Column("tinyint", { name: "directory", width: 1 })
  directory: boolean;

  @OneToMany(
    () => CagettePro,
    cagettePro => cagettePro.vendor2
  )
  cagettePros: CagettePro[];

  @OneToMany(
    () => Catalog,
    catalog => catalog.vendor
  )
  catalogs: Catalog[];

  @OneToMany(
    () => PCatalog,
    pCatalog => pCatalog.vendor
  )
  pCatalogs: PCatalog[];

  @ManyToMany(
    () => CagettePro,
    cagettePro => cagettePro.vendors
  )
  cagettePros2: CagettePro[];

  @ManyToOne(
    () => File,
    file => file.vendors,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "imageId", referencedColumnName: "id" }])
  image: File;

  @ManyToOne(
    () => User,
    user => user.vendors,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;

  @OneToMany(
    () => VendorStats,
    vendorStats => vendorStats.vendor
  )
  vendorStats: VendorStats[];
}
