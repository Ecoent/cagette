import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { File } from "./File";

@Index(
  "EntityFile_fileId_entityType_entityId",
  ["fileId", "entityType", "entityId"],
  {}
)
@Entity("EntityFile", { schema: "db" })
export class EntityFile {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "entityType", length: 64 })
  entityType: string;

  @Column("varchar", { name: "documentType", length: 64 })
  documentType: string;

  @Column("int", { name: "entityId" })
  entityId: number;

  @Column("int", { name: "fileId" })
  fileId: number;

  @ManyToOne(
    () => File,
    file => file.entityFiles,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "fileId", referencedColumnName: "id" }])
  file: File;
}
